import Widget from require "lapis.html"

class AuthRegister extends Widget
	content: => div class:"row", ->
		div class: "col-md-6 col-md-offset-3", id: "mta-auth", ->
			h1 "Register an account"
			
			if @errors
				-- If we have an error, let's tell them the first error
				-- they don't need to know all of them at once!
				div class: "alert alert-danger", role: "alert", @errors[1]

			p "Render login form"