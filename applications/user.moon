lapis = require "lapis"
Users = require "models.users"
db    = require "lapis.db"

import
	capture_errors
	assert_error
from require "lapis.application"

import error_404 from require "utils"

class UserApplication extends lapis.Application
	path: "/user"

	[user_profile: "/:username"]: capture_errors {
		on_error: error_404
		=>
			-- try to find the user by username
			@user = assert_error Users\find [db.raw "lower(username)"]: @params.username\lower!
			@data = @user\get_userdata!
			unless @data
				@data = @user\create_userdata!
			render: true
	}