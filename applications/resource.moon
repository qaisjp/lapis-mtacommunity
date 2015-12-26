lapis = require "lapis"
Users = require "models.users"
db    = require "lapis.db"

import
	capture_errors
	assert_error
from require "lapis.application"

class ResourceApplication extends lapis.Application
	path: "/resources"

	[resources: ""]: capture_errors {
		on_error: =>
			@title = "Oops"
			render: "user_missing"

		=>
			-- try to find the user by username
			-- @profile = assert_error Users\find [db.raw "lower(username)"]: @params.username\lower!
			render: true
	}
	