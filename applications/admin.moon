lapis = require "lapis"
db    = require "lapis.db"

import
	capture_errors
	assert_error
	respond_to
from require "lapis.application"

import
	to_json
from require "lapis.util"

Users = require "models.users"
Resources = require "models.resources"
Bans = require "models.bans"
Screenshots = require "models.resource_screenshots"
UserFollowings = require "models.user_followings"

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
		@gallery_count = Screenshots\count!
		@follows_count = UserFollowings\count!

		render: "admin.layout"
	
	[users: "/users"]: =>
		@title = "Users - Admin"
		render: "admin.layout"

	[bans: "/bans"]: =>
		@title = "Bans - Admin"
		render: "admin.layout"

	[update_bans: "/bans/update"]: capture_errors respond_to
		POST: =>
			Bans.refresh_bans!
			redirect_to: @params.redirect_to or @url_for "admin.bans"

	-- this doesn't work
	[become: "/become/:username"]: log_me_out

	-- this doesn't work either
	-- [become: "/become/:username"]: copied_log_me_out

	-- [become: "/become/:username"]: capture_errors {
	-- 	on_error: => @html -> p @errors[1]

	-- 	=>
	-- 		-- user = assert_error Users\find([db.raw "lower(username)"]: @params.username), "who?"
	-- 		-- user\write_to_session @session
	-- 		-- @html ->
	-- 			-- p "This shows the correct session: #{to_json(@session)}"
	-- 	}