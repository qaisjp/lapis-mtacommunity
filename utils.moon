import
	generate_token
	assert_token
from require "lapis.csrf"
i18n = require "i18n"

generate_csrf_token = =>
	generate_token @, @active_user and @active_user.id

assert_csrf_token = =>
	assert_token @, @active_user and @active_user.id

check_logged_in = =>
	unless @active_user
		@write redirect_to: @url_for "auth.login", nil, return_to: ngx.var.request_uri
		return false
	true

error_bad_request = (err) =>
	@title = i18n "errors.bad_request.title"
	status: 400, @html ->
		h1 i18n "errors.bad_request.h1"
		h3 err or i18n "errors.bad_request.h3"

error_not_authorized = (err) =>
	@title = i18n "errors.not_authorized.title"
	status: 403, @html ->
		h1 i18n "errors.not_authorized.h1"
		h3 err if err

error_404 = (err) =>
	@title = i18n "errors.not_found.title"
	status: 404, @html ->
		h1 i18n "errors.not_found.h1"
		h3 err or i18n "errors.not_found.h3"

error_405 = (err) =>
	@title = i18n "errors.method_disallowed.title"
	status: 405, @html ->
		h1 i18n "errors.method_disallowed.h1"
		h3 err or i18n "errors.method_disallowed.h3"

error_500 = (err) =>
	@title = i18n "errors.server_error.title"
	status: 500, @html ->
		h1 i18n "errors.server_error.h3"
		h3 err if err

get_gravatar_url = (email, size) ->
	hash = ngx.md5 email\lower!
	"https://www.gravatar.com/avatar/#{hash}?s=#{size}"


-- serves a file on the filesystem or redirect to a
-- path internally for serving files
serve_file = (opts) ->
	filepath = opts.filepath
	filename = opts.filename
	external = opts.external
	for k, v in pairs opts.header or {}
		ngx.header[k] = v

	-- if it's on an internal path
	-- we'll let nginx deal with serving
	-- that file.
	unless external
		return ngx.exec "/"..filepath

	file, err = io.open filepath, "r"
	unless file
		return false, err
  
	contents = file\read "*all"
	file\close!

	-- remove the external file
	-- this needs to be here because ngx.exit kills
	-- the entire Lua VM
	os.remove filepath

	-- set the length of the file, so that the browser
	-- can provide a "5/50MB downloaded" indicator
	ngx.header.content_length = #contents

	ngx.say contents
	ngx.exit ngx.OK


-- converts { {"hi"}, {"hello"} } to {"hi", "hello"}
denest_table = (nested, index=1) ->
	tab = {}
	for obj in *nested
		table.insert tab, obj[index]
	tab

{:generate_csrf_token, :assert_csrf_token, :check_logged_in, :error_404, :error_405, :error_500, :error_not_authorized, :error_bad_request, :get_gravatar_url, :serve_file, :denest_table}