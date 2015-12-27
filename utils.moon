import
	generate_token
	assert_token
from require "lapis.csrf"

generate_csrf_token = =>
	generate_token @, @active_user and @active_user.id

assert_csrf_token = =>
	assert_token @, @active_user and @active_user.id

error_404 = (err) =>
	@title = "Page not found"
	status: 404, @html -> div class: "page-header", ->
		h1 "Sorry, this page isn't available"
		h3 err or "The page doesn't exist, but it might have in the past, and it might in the future!"

get_gravatar_url = (email, size) ->
	hash = ngx.md5 email\lower!
	"https://www.gravatar.com/avatar/#{hash}?s=#{size}"

{:generate_csrf_token, :assert_csrf_token, :error_404, :get_gravatar_url}