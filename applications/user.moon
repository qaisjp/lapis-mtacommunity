lapis = require "lapis"
db    = require "lapis.db"
date  = require "date"
import to_json from require "lapis.util"
import
	capture_errors
	assert_error
	respond_to
from require "lapis.application"

import
	error_404
	error_500
	assert_csrf_token
from require "utils"

import
	UserFollowings
	Resources
	ResourceAdmins
	ResourceScreenshots
	Comments
	Users
from require "models"

class UserApplication extends lapis.Application
	path: "/user"
	name: "user."

	@before_filter =>
		-- try to find the user by username
		@user = Users\find [db.raw "lower(slug)"]: @params.username\lower!

		-- throw a 404 if it doesn't exist
		unless @user
			return @write error_404 @

		-- get (or create if it doesn't exist) userdata 
		@data = @user\get_userdata!
		@data = @user\create_userdata! unless @data

	[profile: "/:username"]: capture_errors {
		on_error: error_404
		=>
			if @active_user
				-- get following state
				@isFollowing = @active_user\is_following @user

			tab = @params.tab
			accessed = false -- use this to detect if tab is resources or not

			if tab == "followers"
				@followers = @user\get_followers "users.*, user_followings.created_at as followed_at"
				@followers_count = #@followers
				accessed = true
			else
				@followers_count = UserFollowings\count "following = ?", @user.id

			if tab == "following"
				@following = @user\get_following "users.*, user_followings.created_at as followed_at"
				@following_count = #@following
				accessed = true
			else
				@following_count = UserFollowings\count "follower  = ?", @user.id

			if tab == "screenshots"
				@screenshots = @user\get_screenshots!
				Resources\include_in @screenshots, "resource", as: "resource"

				@screenshots_count = #@screenshots
				accessed = true
			else
				@screenshots_count = ResourceScreenshots\count "uploader = ?", @user.id
			
			if tab == "comments"
				@comments = @user\get_comments!
				Users\include_in @comments, "author", as: "author"

				@comments_count = #@comments
				accessed = true
			else
				@comments_count = Comments\count "author = ?", @user.id

			if accessed
				@resources_count = (Resources\count "creator = ?", @user.id) + (ResourceAdmins\count "\"user\" = ?", @user.id)
			else
				@resources = @user\get_resources!
				@resources_count = #@resources

			render: true
	}

	[follow: "/:username/follow"]: capture_errors respond_to
		on_error: error_500
		before: =>
			if @active_user.id == @user.id
				@write status:400, "<h1>You cannot follow yourself</h1>"
			@isFollowing = @active_user\is_following @user

		GET: =>	render: true

		POST: capture_errors =>
			assert_csrf_token @

			if @params.intent == "follow"
				if @isFollowing
					return status: 400, "<h1>You are already following this person</h1>"

				UserFollowings\create {follower: @active_user.id, following: @user.id}

			elseif @params.intent == "unfollow"
				unless @isFollowing
					return status: 400, "<h1>You are not following this person</h1>"

				uf = UserFollowings\find {follower: @active_user.id, following: @user.id}
				uf\delete! if uf

			redirect_to: @url_for "user.profile", (username: @user.slug), (tab: @params.tab)
