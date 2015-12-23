import Model, enum from require "lapis.db.model"
import slugify from require "lapis.util"

bcrypt = require "bcrypt"
config = require("lapis.config").get!
db     = require "lapis.db"
Bans   = require "models.bans"

class Users extends Model
	-- Has created_at and modified_at
	@timestamp: true
	
	@relations: {
		{"bans", has_many: "Bans", key: "banned_user"}
		{"active_bans", has_many: "Bans", key: "banned_user", where: active: true}
	}

	-- authentication levels
	@levels: enum
		guest: 1
		admin: 2

	-- Only primary key defined is "id"
	-- excluded because ID is the default primary key
	-- @primary_key: "id"

	-- Create a new user, given the following:
	@register: (username, password, email) =>
		-- First check if the username is unique
		if @check_unique_constraint "username", username 
			return nil, "Username already exists"

		-- For some reason, people might use their email as a username too
		-- We don't like that. At all.
		if @check_unique_constraint "username", email
			return nil, "Username already exists"

		slug = slugify username
		if @check_unique_constraint "slug", slug
			return nil, "Username already exists"

		-- Now check email
		if @check_unique_constraint "email", email
			return nil, "Account already exists"

		-- I'm not even sure if we even need this, but, why not?
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
		password = bcrypt.digest password, config.bcrypt_log_rounds

		-- And create the database row!
		@create { :username, :slug, :password, :email }


	@login: (username, password) =>
		local user
		with uname_l = username\lower!
			user = Users\find [db.raw "lower(username)"]: uname_l
			user = Users\find [db.raw "lower(email)"]: uname_l unless user

		unless user and bcrypt.verify password, user.password
			return nil, "Incorrect username or password."

		unless user.activated
			return nil, "Your account has not been activated."

		if user\is_banned!
			return nil, "You are banned."

		user

	write_to_session: (session) =>
		session.user_id = @id

	is_banned: =>
		Bans.refresh_bans @
		#@get_active_bans! > 0
		-- true