lapis = require "lapis"

import assert_csrf_token from require "utils"
import assert_valid from require "lapis.validate"
import
	respond_to
	capture_errors
	assert_error
from require "lapis.application"




Users = require "models.users"

class AuthApplication extends lapis.Application
	["auth.login": "/login"]: respond_to {
		before: =>
			@title = "Login"

		GET: =>
			render: true

		POST: capture_errors {
			on_error: =>
				render: "auth.login"

			=>
				assert_csrf_token @
				assert_valid @params, {
					{ "username", type: "string", exists: true, max_length: 255 }
					{ "password", type: "string", exists: true }
				}

				remember = @params.remember == "true"
				user = assert_error Users\login @params.username, @params.password
				
				-- We will always succeed, so let's redirect to the homepage
				redirect_to: @url_for "home"
		}
	}

	["auth.register": "/register"]: respond_to {
		before: => 
			@title = "Register"

		GET: => @html ->
			p "Register me up dawg"

		POST: capture_errors {
			on_error: =>
				render: "auth.register"

			=>
				assert_csrf_token @

				-- Again, always succeeding be we never fail
				redirect_to: @url_for "home"
		}
	}


	["auth.forgot": "/password_reset"]: respond_to {
		before: =>
			@title = "Reset your password"

		GET: => @html -> h1 "Reset your password"

		POST: capture_errors {
			on_error: =>
				render: "auth.forgot"

			=>
				assert_csrf_token @
		}
	}