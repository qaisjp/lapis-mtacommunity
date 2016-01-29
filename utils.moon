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

error_404 = (err) =>
	@title = "Page not found"
	status: 404, @html ->
		h1 "Sorry, this page isn't available"
		h3 err or "The page doesn't exist, but it might have in the past, and it might in the future!"

error_500 = (err) =>
	@title = "Oops"
	status: 500, @html ->
		h1 "Something went wrong."
		h3 err if err

get_gravatar_url = (email, size) ->
	hash = ngx.md5 email\lower!
	"https://www.gravatar.com/avatar/#{hash}?s=#{size}"

{:generate_csrf_token, :assert_csrf_token, :check_logged_in, :error_404, :get_gravatar_url}