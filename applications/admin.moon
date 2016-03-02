lapis = require "lapis"
db    = require "lapis.db"
import assert_csrf_token from require "utils"
import assert_valid from require "lapis.validate"
import
	capture_errors
	assert_error
	respond_to
from require "lapis.application"
import
	to_json
from require "lapis.util"
import
	Users
	Resources
	Bans
	ResourceScreenshots
	UserFollowings
from require "models"
import error_404, error_500 from require "utils"

class AdminApplication extends lapis.Application
	path: "/admin"
	name: "admin."

	@before_filter =>
		-- limit this entire application to certain users
		unless @active_user and (@active_user.level >= Users.levels.QA)
			@write error_404 @

	[dashboard: ""]: =>
		@title = "Admin"

		-- generate statistics
		@user_count = Users\count!
		@resource_count = Resources\count!
		@ban_count = Bans\count!
		@banned_users_count = Bans\count "active = true"
		@gallery_count = ResourceScreenshots\count!
		@follows_count = UserFollowings\count!

		render: "admin.layout"
	
	[users: "/users"]: =>
		@title = "Users - Admin"
		@page = math.max 1, tonumber(@params.page) or 1 -- for pagination
		render: "admin.layout"

	[manage_user: "/users/:user_id"]: capture_errors {
		on_error: => error_500 @, @errors[1]
		=> 
			@title = "Users - Admin"
			assert_valid @params, {
				-- exists is probably redundant here
				{"user_id", exists: true, is_integer: true}
			}

			@user = assert_error (Users\find @params.user_id), "user does not exist"
			render: "admin.layout"
	}

	[bans: "/bans"]: =>
		@title = "Bans - Admin"
		@page = math.max 1, tonumber(@params.page) or 1 -- for pagination
		render: "admin.layout"

	[view_ban: "/bans/:ban_id"]: capture_errors {
		on_error: => error_500 @, @errors[1]
		=> 
			@title = "Bans - Admin"
			assert_valid @params, {
				-- exists is probably redundant here
				{"ban_id", exists: true, is_integer: true}
			}

			@ban = assert_error Bans\find(@params.ban_id), "ban does not exist"
			@banned_user = @ban\get_receiver!
			@banner = @ban\get_sender!

			render: "admin.layout"
	}

	[update_bans: "/bans/update"]: respond_to
		POST: capture_errors =>
			Bans.refresh_bans tonumber(@params.id)
			redirect_to: @params.redirect_to or @url_for "admin.bans"

	[become: "/become"]: capture_errors respond_to {
		on_error: => @html -> p @errors[1]
		GET: => status: 404
		POST: =>
			assert_csrf_token @
			
			assert_valid @params, {
				{"user_id", exists: true, is_integer: true}
			}
			user = assert_error Users\find @params.user_id
			user\write_to_session @session
			redirect_to: @url_for "home"
	}

	-- This is a debugging feature that is not required.
	[console: "/console"]: (->
		exists, console = pcall(require, "lapis.console")
		if exists
			return console.make!
		else
			return -> "Feature not available."
		)!
