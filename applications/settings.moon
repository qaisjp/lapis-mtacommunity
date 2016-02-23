lapis = require "lapis"
Users = require "models.users"
db    = require "lapis.db"

import
	capture_errors
	assert_error
	respond_to
from require "lapis.application"

import
	check_logged_in
	error_404
	error_405
	error_500
from require "utils"

class SettingsApplication extends lapis.Application
	path: "/settings"
	name: "settings."

	@before_filter => check_logged_in @


	[main: ""]: => redirect_to: @url_for "settings.profile"
		
	[profile: "/profile"]: => render: "settings.layout"
	[account: "/account"]: => render: "settings.layout"

	[delete: "/delete"]: capture_errors respond_to
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't delete your account."
		GET: error_405
		POST: =>
			-- clear session user id
			@session.user_id = nil
			@active_user\delete!
			redirect_to: @url_for "home"