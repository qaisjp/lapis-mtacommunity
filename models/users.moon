import Model from require "lapis.db.model"
import slugify from require "lapis.util"

bcrypt = require "bcrypt"
config = require("lapis.config").get!

class Users extends Model
	-- Has created_at and modified_at
	@timestamp: true
   	
   	-- Only primary key defined is "id"
   	-- excluded because ID is the default primary key
   	-- @primary_key: "id"

   	@create: (username, password, email) =>
   		-- First check if the username is unique
   		slug = slugify username
		if (@check_unique_constraint "username", username) or (@check_unique_constraint "slug", slug)
			return nil, "Username already exists"

		-- Now check email
		if @check_unique_constraint "email", email
			return nil, "Account already exists"

		-- Generate the password
		password = bcrypt.digest password, config.bcrypt_log_rounds

		-- And create the database!
		super\create { :username, :slug, :password, :email }
