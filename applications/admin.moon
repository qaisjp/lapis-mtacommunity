lapis = require "lapis"
db    = require "lapis.db"

import
	capture_errors
	assert_error
from require "lapis.application"

Users = require "models.users"

class AdminApplication extends lapis.Application
	path: "/admin"
	name: "admin."

	@before_filter =>
		if (not @active_user) or (@active_user.level != Users.levels.admin)
			@write redirect_to: @url_for "home"

	[dashboard: ""]: =>
		@title = "Admin"
		render: "admin.layout"
	
	[users: "/users"]: =>
		@title = "Users - Admin"
		render: "admin.layout"

	[bans: "/bans"]: =>
		@title = "Bans - Admin"
		render: "admin.layout"

	[become: "/become/:username"]: capture_errors {
		on_error: => @html -> p @errors[1]

		=>
			user = assert_error Users\find([db.raw "lower(username)"]: @params.username), "who?"
			user\write_to_session @session
			redirect_to: @url_for "home"
		}