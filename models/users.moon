import Model, enum from require "lapis.db.model"

slugify_username = (username) ->
	import slugify from require "lapis.util"
	slugify username

bcrypt = require "bcrypt"
db     = require "lapis.db"

import
	Bans
	UserData
from require "models"

class Users extends Model
	-- Has created_at and modified_at
	@timestamp: true
	
	@relations: {
		{"bans", has_many: "Bans", key: "banned_user"}
		{"active_bans", has_many: "Bans", key: "banned_user", where: active: true}
		{"comments", has_many: "Comments", key: "author"}
		{"userdata", has_one: "UserData"}
		{"follows", has_many: "UserFollowings", key: "follower", order: "created_at desc"}
		{"followed_by", has_many: "UserFollowings", key: "following", order: "created_at desc"}
	}

	-- authentication levels
	@levels: enum
		guest: 1
		QA:    2
		admin: 3

	-- Only primary key defined is "id"
	-- excluded because ID is the default primary key
	-- @primary_key: "id"

	url_key: (route_name) => @slug
	url_params: (reg, ...) => "user.profile", { username: @ }, ...

	-- Create a new user, given the following:
	@register: (username, password, email) =>
		-- First check if the username is unique
		if @check_unique_constraint "username", username 
			return nil, "Username already exists"

		-- For some reason, people might use their email as a username too
		-- We don't like that. At all.
		if @check_unique_constraint "username", email
			return nil, "Username already exists"

		slug = slugify_username username
		if @check_unique_constraint "slug", slug
			return nil, "Username already exists"

		-- Now check email
		if @check_unique_constraint "email", email
			return nil, "Account already exists"

		-- I'm not even sure if we even need this...
		if @check_unique_constraint "email", username
			return nil, "Account already exists"

		-- We should also check if a case-insensitive
		-- version of the email is available
		-- We kinda want to treat emails case-insensitively,
		-- but store the email sensitively in the unlikely
		-- case that their email is actually case-sensitive
		-- ^ no pun intended
		if Users\find [db.raw "lower(email)"]: email\lower!
			return nil, "Account already exists"

		-- Generate the password
		password = Users\generate_password password

		-- And create the database row!
		user = @create { :username, :slug, :password, :email }
		user\create_userdata!
		user


	@login: (username, password) =>
		local user
		with uname_l = username\lower!
			user = Users\find [db.raw "lower(username)"]: uname_l
			user = Users\find [db.raw "lower(slug)"]: uname_l unless user
			user = Users\find [db.raw "lower(email)"]: uname_l unless user

		unless user and user\check_password password
			return nil, "Incorrect username or password."

		unless user.activated
			return nil, "Your account has not been activated."

		if user\is_banned!
			return nil, "You are banned."

		user -- return user

	@generate_password: (password) =>
		config = require("lapis.config").get! -- Get the config (we don't need to load it every request)
		bcrypt.digest password, config.bcrypt_log_rounds

	rename: (newName) =>
		if Users\check_unique_constraint "username", newName	
			return nil, "Username already exists"

		slug = slugify_username newName	
		if Users\check_unique_constraint "slug", slug
			return nil, "Username already exists"

		-- i think lapis sanitises this
		@username = newName
		@slug = slug
		@update "username", "slug"
		true

	check_password: (password) => bcrypt.verify password, @password
	update_password: (password) =>
		@password = Users\generate_password password -- update password
		@update "password" -- commit to database

	-- log the current user into the session
	write_to_session: (session) =>
		session.user_id = @id

	is_banned: =>
		Bans.refresh_bans @
		#@get_active_bans! > 0

	create_userdata: => UserData\create user_id: @id

	is_following: (other_user) =>
		(db.select "EXISTS(SELECT 1 FROM user_followings WHERE follower = ? AND following = ?)",
			@id,
			other_user.id
		)[1].exists


	get_followers: (fields="users.*") =>
		Users\select ", user_followings where (following = ?) and (users.id = follower)",
			@id,
			:fields

	get_following: (fields="users.*") =>
		Users\select ", user_followings where (follower = ?) and (users.id = following)",
			@id,
			:fields

	is_guest: => @level <= 1 

	can_manage: (user) => -- can this user manage a specific user?
		(not @is_guest!) and (@level >= user.level)

	can_open_admin_panel: => -- can this user administrate the website?
		@level >= Users.levels.QA

	get_resources: (fields="resources.*") =>
		import Resources from require "models" -- req it here because you don't want an infinite loop
		Resources\select [[
    		-- The columns we're looking through...
    		, users, resource_admins

    		WHERE
    		(
    			-- Is the user the creator
	    		(resources.creator = users.id)

	    		OR
	    		(
	    			(resource_admins.user = users.id) -- Make sure they are an admin...
	    			AND (resource_admins.resource = resources.id) -- ... of the correct resource...
	    			AND (resource_admins.user_confirmed) -- but make sure they've confirmed the request!
	    		)
    		)

			-- Make sure we're looking for the ones from the right users
			AND (users.id = ?)			
    	]], @id, fields: "DISTINCT ON (resources.id) #{fields}"