import Model from require "lapis.db.model"
import slugify from require "lapis.util"

bcrypt = require "bcrypt"
config = require("lapis.config").get!

class Resources extends Model
    -- Has created_at and modified_at
    @timestamp: true
    
    -- Only primary key defined is "id"
    -- excluded because ID is the default primary key
    -- @primary_key: "id"

    -- Create a new user, given the following:
    @create: (username, password, email) =>
        -- First check if the username is unique
        if @check_unique_constraint "username", username 
            return nil, "Username already exists"

        slug = slugify username
        if @check_unique_constraint "slug", slug
            return nil, "Username already exists"

        -- Now check email
        if @check_unique_constraint "email", email
            return nil, "Account already exists"

        -- Generate the password
        password = bcrypt.digest password, config.bcrypt_log_rounds

        -- And create the database row!
        super\create { :username, :slug, :password, :email }

