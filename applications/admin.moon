lapis = require "lapis"
db    = require "lapis.db"
date  = require "date"

import assert_csrf_token from require "utils"
import assert_valid from require "lapis.validate"
import
	capture_errors
	assert_error
	respond_to
	yield_error
from require "lapis.application"

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

	[reports: "/reports(/:resource_id[%d])"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1]
		GET: => render: "admin.layout"
		-- POST to retire all reports for resources
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{"resource_id", exists: true, is_integer: true}
			}
			db.delete "resource_reports", resource: @params.resource_id
			render: "admin.layout"
	}

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

	[new_ban: "/bans/new"]: capture_errors respond_to {
		before: =>
			if user_id = @params.user_id
				assert_valid @params, {
					{"user_id", is_integer: true, exists: true}
				}

				-- does thw user we want to ban exist?
				user = Users\find user_id
				if user
					@user = user
				else
					@errors = {"User does not exist"}
					return @write render: "admin.layout"

		on_error: => render: "admin.layout"
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{"ban_expiry_date", exists: true}
				{"ban_expiry_time", exists: true}
				{"ban_reason"     , exists: true}
			}

			-- attempt to read date/time and get the target date
			success, expiry_date = pcall -> (date @params.ban_expiry_date) + (date @params.ban_expiry_time)
			yield_error "Date or time is in the incorrect format" unless success

			-- ensure date is in the future
			assert_error (expiry_date > date!), "Ban must be in the future"
			
			-- create the ban
			ban = Bans\create banner: @active_user.id, banned_user: @user.id, reason: @params.ban_reason, active: true, expires_at: expiry_date\fmt "${http}"
			assert_error ban, "Failed to create ban"
			redirect_to: @url_for "admin.view_ban", ban_id: ban.id

		GET: => 
			@title = "Bans - Admin"

			if username = @params.search_user
				return redirect_to: @url_for "admin.new_ban" if (username == "") or (username == true)

				if user = Users\search username
					return redirect_to: @url_for "admin.new_ban", nil, user_id: user.id
				
				@errors = {"Could not find user \"username\""}

			

			render: "admin.layout"
	}

	[update_bans: "/bans/update_bans"]: respond_to
		POST: capture_errors =>
			assert_csrf_token @
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
