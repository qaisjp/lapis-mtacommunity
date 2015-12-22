import Widget from require "lapis.html"
LoginForm = require "widgets.login_form"

class AuthLogin extends Widget
	content: => div class:"row", ->
		div class: "col-md-6 col-md-offset-3", id: "mta-login", ->
			h1 "Login"
			if @login_success
				div class: "alert alert-success", role: "alert", "You have successfully logged in"
				p "You are now being redirected to the homepage..."
				return
			elseif @errors
				-- If we have an error, let's tell them the first error
				-- they don't need to know all of them at once!
				div class: "alert alert-danger", role: "alert", @errors[1]

			widget LoginForm