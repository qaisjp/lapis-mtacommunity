lapis = require "lapis"
db    = require "lapis.db"

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

copied_log_me_out = =>
	@session.user_id = nil
	redirect_to: @url_for "home"

class AdminApplication extends lapis.Application
	path: "/admin"
	name: "admin."

	-- @before_filter =>
		-- if (not @active_user) or (@active_user.level != Users.levels.admin)
			-- @write redirect_to: @url_for "home"

	[dashboard: ""]: =>
		@title = "Admin"
		@user_count = Users\count!
		@resource_count = Resources\count!
		@ban_count = Bans\count!
		@banned_users_count = Bans\count "active = true"
		@gallery_count = ResourceScreenshots\count!
		@follows_count = UserFollowings\count!
		render: "admin.layout"
	
	[users: "/users"]: =>
		@title = "Users - Admin"
		@page = math.max 1, tonumber(@params.page) or 1
		render: "admin.layout"

	[bans: "/bans"]: =>
		@title = "Bans - Admin"
		@page = math.max 1, tonumber(@params.page) or 1
		render: "admin.layout"

	[view_ban: "/bans/:ban_id"]: capture_errors {
		on_error: => @html -> p to_json @errors
		=> 
			@title = "Bans - Admin"
			assert_valid @params, {
				-- exists is probably redundant here
				{"ban_id", exists: true, is_integer: true}
			}

			@ban = assert_error (Bans\find @params.ban_id), "ban does not exist"
			render: "admin.layout"
	}	
	

	[update_bans: "/bans/update"]: respond_to
		POST: capture_errors => 
			Bans.refresh_bans!
			redirect_to: @params.redirect_to or @url_for "admin.bans"

	-- this doesn't work
	-- [become: "/become/:username"]: log_me_out

	-- this doesn't work either
	-- [become: "/become/:username"]: copied_log_me_out

	[become: "/become"]: capture_errors respond_to {
		on_error: => @html -> p @errors[1]
		GET: => status: 404
		POST: =>
			assert_valid @params, {
				{"user_id", exists: true, is_integer: true}
			}
			user = assert_error Users\find @params.user_id
			user\write_to_session @session
			-- @session.user_id = false
			redirect_to: @url_for "home"
			-- @html ->
				-- p "This shows the correct session: #{to_json(@session)}"
	}