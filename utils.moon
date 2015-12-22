import
	generate_token
	assert_token
from require "lapis.csrf"

generate_csrf_token = =>
	generate_token @, @active_user and @active_user.id

assert_csrf_token = =>
	assert_token @, @active_user and @active_user.id


{:generate_csrf_token, :assert_csrf_token}