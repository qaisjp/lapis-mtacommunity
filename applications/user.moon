lapis = require "lapis"
Users = require "models.users"
db    = require "lapis.db"
date  = require "date"
import to_json from require "lapis.util"
import
	capture_errors
	assert_error
	respond_to
from require "lapis.application"

import error_404 from require "utils"
import
	UserFollowings
	Resources
	ResourceAdmins
	ResourceScreenshots
	Comments
from require "models"

class UserApplication extends lapis.Application
	path: "/user"
	name: "user."

	@before_filter =>
		-- try to find the user by username
		@user = Users\find [db.raw "lower(username)"]: @params.username\lower!
		unless @user
			return @write error_404 @

		@data = @user\get_userdata!
		unless @data
			@data = @user\create_userdata!

	[profile: "/:username"]: capture_errors {
		on_error: error_404
		=>
			if @active_user
				@isFollowing = @active_user\is_following @user

			@followers = UserFollowings\count "following = ?", @user.id
			@following = UserFollowings\count "follower  = ?", @user.id

			registration_date = date @user.created_at
			@registration_date = registration_date\fmt "%d %b %Y"

			@resource_count = (Resources\count "creator = ?", @user.id) + (ResourceAdmins\count "\"user\" = ?", @user.id)
			@screenshot_count = ResourceScreenshots\count "uploader = ?", @user.id
			@comment_count = Comments\count "author = ?", @user.id
			render: true
	}

	[follow: "/:username/follow"]: capture_errors respond_to
		on_error: =>
			status: 500, "Internal server error"
		before: =>
			if @active_user.id == @user.id
				@write status:400, "<h1>You cannot follow yourself</h1>"
			@isFollowing = @active_user\is_following @user
		GET: =>	render: true
		POST: capture_errors => 
			if (@params.intent == "follow") 
				if @isFollowing
					return @write status: 400, "<h1>You are already following this person</h1>"
				UserFollowings\create {follower: @active_user.id, following: @user.id}
			elseif (@params.intent == "unfollow") 
				unless @isFollowing
					return @write status:400, "<h1>You are not following this person</h1>"
				uf = UserFollowings\find {follower: @active_user.id, following: @user.id}
				uf\delete! if uf
			redirect_to: @url_for "user.profile", username: @user.username
