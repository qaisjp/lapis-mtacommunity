lapis = require "lapis"
Users = require "models.users"
db    = require "lapis.db"
date  = require "date"
import assert_csrf_token from require "utils"
import
	capture_errors
	yield_error
	assert_error
	respond_to
from require "lapis.application"
import assert_valid from require "lapis.validate"
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
		
	[profile: "/profile"]: capture_errors respond_to
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't make those changes."
		GET: =>
			@data = @active_user\get_userdata!
			render: "settings.layout"
		POST: =>
			assert_error @
			assert_valid @params, {
				{ "settingsGang", max_length: 255 },
				{ "settingsLocation", max_length: 255 },
				{ "settingsWebsite", max_length: 255 }
			}
			
			@data = @active_user\get_userdata!

			success, birthday = pcall date, @params.settingsDate
			@data.birthday = success and birthday\fmt("%Y-%m-%d") or nil

			@data.privacy_mode = (tonumber(@params.settingsPrivacy) == 2) and 2 or 1
			@data.gang = @params.settingsGang
			@data.location = @params.settingsLocation
			@data.website = @params.settingsWebsite
			assert_error @data\update "birthday", "privacy", "gang", "location", "website"
			render: "settings.layout"

	[account: "/account"]: => render: "settings.layout"

	[delete_account: "/delete_account"]: capture_errors respond_to
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't delete your account."
		GET: error_405
		POST: =>
			assert_csrf_token @
			-- clear session user id
			@session.user_id = nil
			@active_user\delete!
			redirect_to: @url_for "home"

	[rename_account: "/rename_account"]: capture_errors respond_to
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't rename your account."
		GET: error_405
		POST: => 
			assert_csrf_token @
			assert_valid @params, {
				{ "settingsNewUsername", exists: true, min_length: 1, max_length: 255 }
			}
			assert_error @active_user\rename @params.settingsNewUsername
			redirect_to: @url_for "settings.account"

	[change_password: "/change_password"]: capture_errors respond_to
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't change your password."
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{ "settingsOldPassword", exists: true }
				{ "settingsNewPassword", exists: true }
				{ "settingsNewPasswordConfirm", exists: true, equals: @params.settingsNewPassword }
			}

			unless @active_user\check_password @params.settingsOldPassword
				return yield_error "Your old password is incorrect."
				-- note: yield_error kills the function i think but put "return" to make it obvious

			@active_user\update_password @params.settingsNewPassword
			redirect_to: @url_for "settings.account" -- send them back to the account page