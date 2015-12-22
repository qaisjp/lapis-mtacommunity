import Widget from require "lapis.html"
LoginForm = require "widgets.login_form"

class AuthLogin extends Widget
	content: => div class:"row", ->
		div class: "col-md-4 col-md-offset-4", id: "mta-auth", ->
			h1 "Login"
			if @errors
				-- If we have an error, let's tell them the first error
				-- they don't need to know all of them at once!
				div class: "alert alert-danger", role: "alert", @errors[1]

			widget LoginForm