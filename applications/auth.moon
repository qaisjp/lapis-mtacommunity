lapis = require "lapis"
nginx = require("lapis.nginx.http")
date  = require "date"

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
from require "models"

class AuthApplication extends lapis.Application
  name: "auth."
  
  [login: "/login"]: respond_to
	before: =>
	  @title = "Login"

	GET: => render: true
	POST: capture_errors {
	  -- on_error: => render: true
	  =>
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
		redirect_to: @params.return_to or @url_for "home"
	}

  [register: "/register"]: capture_errors respond_to
	on_error: => render: true
	before: => 
	  @title = "Register"

	GET: => render: true
	POST: =>
	  assert_csrf_token @
	  assert_valid @params, {
		{ "username", type: "string", exists: true, max_length: 255 }
		{ "password", type: "string", exists: true }
		{ "password_confirm", type: "string", exists: true, equals: @params.password }
		{ "email", type: "string", exists: true }
	  }

	  -- TODO: Fix recaptcha
	  -- Now we need to check the recaptcha
	  -- res = nginx.simple
	  --  method: nginx.methods.post
	  --  url:  "https://www.google.com/recaptcha/api/siteverify"
	  --  vars: 
	  --    secret: captcha_secret
	  --    response: @params["g-recaptcha-response"]
	  -- assert_error res.success == true, "captcha fail"

	  -- Create the user
	  user = assert_error Users\register @params.username, @params.password, @params.email

	  -- TODO: Add email activation
	  -- In the absence of email activation, lets just activate accounts immediately
	  user\update activated: true

	  @success = true
	  render: true
  
  [logout: "/logout"]: =>
	-- clear session user id
	@session.user_id = nil
	redirect_to: @url_for "home"

  -- TODO
  [forgot: "/password_reset"]: respond_to
	before: =>
	  @title = "Reset your password"

	GET: => @html -> h1 "Reset your password"

	POST: capture_errors {
	  on_error: =>
		json: @errors

	  =>
		assert_csrf_token @
	}