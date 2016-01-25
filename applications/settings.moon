lapis = require "lapis"
Users = require "models.users"
db    = require "lapis.db"

import
	capture_errors
	assert_error
from require "lapis.application"

import
	check_logged_in
from require "utils"

class SettingsApplication extends lapis.Application
	path: "/settings"
	name: "settings."

	@before_filter => check_logged_in @


	[main: ""]: => redirect_to: @url_for "settings.profile"
		
	[profile: "/profile"]: assert_error =>
		render: true
	