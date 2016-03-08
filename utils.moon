import
	generate_token
	assert_token
from require "lapis.csrf"

generate_csrf_token = =>
	generate_token @, @active_user and @active_user.id

assert_csrf_token = =>
	assert_token @, @active_user and @active_user.id

check_logged_in = =>
	unless @active_user
		@write redirect_to: @url_for "auth.login", nil, return_to: ngx.var.request_uri
		return false
	true

error_not_authorized = (err) =>
	@title = "Not Authorized"
	status: 403, @html ->
		h1 "Sorry, you can't access this page."
		h3 err if err

error_404 = (err) =>
	@title = "Page not found"
	status: 404, @html ->
		h1 "404: Sorry, this page isn't available"
		h3 err or "The page doesn't exist, but it might have in the past, and it might in the future!"

error_405 = (err) =>
	@title = "Error 405"
	status: 405, @html ->
		h1 "405: Sorry, this page isn't available"
		h3 err or "The page doesn't exist, but it might have in the past, and it might in the future!"

error_500 = (err) =>
	@title = "Oops"
	status: 500, @html ->
		h1 "Something went wrong."
		h3 err if err

get_gravatar_url = (email, size) ->
	hash = ngx.md5 email\lower!
	"https://www.gravatar.com/avatar/#{hash}?s=#{size}"


-- serves a file on the filesystem or redirect to a
-- path internally for serving files
serve_file = (filepath, filename, mime_type, external) ->
	-- set the correct mime type, so the browser doesn't display
	-- knows how to deal with this type of file
	ngx.header.content_type = mime_type

	-- make the browser download the file instead of showing it inline
	-- set the filename
	ngx.header.content_disposition = "attachment; filename=\"#{filename}\""

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

{:generate_csrf_token, :assert_csrf_token, :check_logged_in, :error_404, :error_405, :error_500, :error_not_authorized, :get_gravatar_url, :serve_file, :denest_table}