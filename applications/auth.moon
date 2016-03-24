lapis = require "lapis"
db    = require "lapis.db"
nginx = require "lapis.nginx.http"
date  = require "date"
i18n  = require "i18n"
import assert_csrf_token from require "utils"
import assert_valid from require "lapis.validate"
import
	respond_to
	capture_errors
	assert_error
	yield_error
from require "lapis.application"
import error_500 from require "utils"
import
	Users
	UserTokens
from require "models"

class AuthApplication extends lapis.Application
	name: "auth."

	[login: "/login"]: capture_errors respond_to
		before: => @title = i18n "auth.login_title"
		GET: => render: true
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{ "username", type: "string", exists: true, max_length: 255 }
				{ "password", type: "string", exists: true }
			}

			-- Get the user they are trying to log in to
			user = assert_error Users\login @params.username, @params.password

			-- Write an expiry date for the cookie
			@session.cookie_expiry = (@params.remember == "true") and
			date(true)\addmonths(1)\fmt "${http}" or 0

			-- Write the active_user to the session
			user\write_to_session @session

			-- We will always succeed, so let's redirect to the homepage
			redirect_to: @params.return_to

	[register: "/register"]: capture_errors respond_to
		on_error: => render: true
		before: => @title = i18n "auth.register_title"

		GET: => render: true
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{ "username", type: "string", exists: true, max_length: 255 }
				{ "password", type: "string", exists: true }
				{ "password_confirm", type: "string", exists: true, equals: @params.password }
				{ "email", type: "string", exists: true }
			}

			-- Create the user
			user = assert_error Users\register @params.username, @params.password, @params.email

			-- In the absence of email activation, lets just activate accounts immediately
			user\update activated: true

			@success = true
			render: true
  
	[logout: "/logout"]: =>
		-- clear session user id
		@session.user_id = nil
		redirect_to: @url_for "home"

	[forgot: "/password_reset(/*)"]: capture_errors respond_to
		before: =>
			@title = i18n "auth.reset_title"

			-- check if the token exists
			@token_type = UserTokens.token_type\for_db "reset_password"

			if @params.splat
				token = UserTokens\find id: @params.splat, type: @token_type
				 
				if not token
					yield_error	i18n "users.errors.token_not_exist"
					@params.splat = nil
				elseif (token.expires_at != 0) and ( date(token.expires_at) < date! )
					token\delete!
					@params.splat = nil
					yield_error	i18n "users.errors.token_expired"
				@token = token
		GET: => render: true
		POST: =>
			assert_csrf_token @

			if @token
				-- reset password
				assert_valid @params, {
					{"password", exists: true},
					{"password_confirm", exists: true, equals: @params.password, i18n "users.errors.password_confirm_mismatch"}
				}
				@token\delete!
				user = Users\find @token.owner
				user\update_password @params.password
				return redirect_to: @url_for "home"

			-- send reset email

			assert_valid @params, {
				{"email", exists: true}
			}

			user = assert_error Users\select("where lower(email) = ? limit 1", @params.email)[1], i18n "users.errors.not_exist"

			config = require("lapis.config").get! -- Get the config (we don't need to load it every request)
			bcrypt = require "bcrypt"
			
			db.delete "user_tokens", owner: user.id, type: @token_type
			local token
			while not token
				token = bcrypt.digest(user.email, config.bcrypt_log_rounds)\sub(-20)
				if UserTokens\find id: token, type: @token_type
					token = nil

			assert_error UserTokens\create id: token, type: @token_type, owner: user.id, expires_at: (date! + date hour: 6)\fmt "${http}"

			secrets = require "secrets"
			import Mailgun from require "mailgun"

			url = @build_url @url_for "auth.forgot", splat: token
			gunner = Mailgun secrets.mailgun
			assert_error gunner\send_email -- actually send the email now
			    to: "me@qaisjp.com"
			    subject: "#{i18n 'email.reset.subject'}"
			    html: true
			    body: "<h1>#{i18n 'email.reset.h1'}</h1><p>#{i18n 'email.reset.note'}<p><p><a href=\"#{url}\">#{url}</a></p>"

			@success = true
			render: true
