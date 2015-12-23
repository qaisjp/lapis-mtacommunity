lapis = require "lapis"
Users = require "models.users"
db    = require "lapis.db"

import
	capture_errors
	assert_error
from require "lapis.application"

class UserApplication extends lapis.Application
	[user_profile: "/user/:username"]: capture_errors {
		on_error: =>
			render: "user_missing"

		=>
			-- try to find the user by username
			@profile = assert_error Users\find [db.raw "lower(username)"]: @params.username\lower!
			render: true
	}
	