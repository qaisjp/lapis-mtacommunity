import Widget from require "lapis.html"
import write_csrf_input from require "utils"

class AuthRegister extends Widget
	@include "widgets.utils"
	
	content: =>
		@content_for "post_body_script", ->
			script src: 'https://www.google.com/recaptcha/api.js'

		div class:"row", -> div class: "col-md-4 col-md-offset-4", id: "mta-auth", ->
			h1 "Register an account"
			
			if @errors
				-- If we have an error, let's tell them the first error
				-- they don't need to know all of them at once!
				div class: "alert alert-danger", role: "alert", @errors[1]
			elseif @success
				div class: "alert alert-success", role: "alert", "Account successfully created. Your account has been automatically activated."

			form id: "mta-register-form", method: "POST", action: @url_for("auth.register"), ->
				-- csrf token to prevent cross-side-request-forgery (who would've guessed?)
				@write_csrf_input!

				div class: "input-group input-group-sm", ->
					span class: "input-group-addon", -> i class: "fa fa-fw fa-user"
					input type: "text", class: "form-control", placeholder: "username", autocomplete: "on", name: "username", value: @params.username, required: true

				div class: "row", ->
					div class: "col-md-6", ->
						div class: "input-group input-group-sm", ->
							span class: "input-group-addon", -> i class: "fa fa-fw fa-key"
							input type: "password", class: "form-control", placeholder: "password", autocomplete: "on", name: "password", oninput: "check_register_validity()", required: true
						

					div class: "col-md-6", ->
						div class: "input-group input-group-sm", ->
							span class: "input-group-addon", -> i class: "fa fa-fw fa-repeat"
							input type: "password", class: "form-control", placeholder: "confirm", autocomplete: "on", name: "password_confirm", oninput: "check_register_validity()", required: true

				div class: "input-group input-group-sm", ->
					span class: "input-group-addon", -> i class: "fa fa-fw fa-envelope"
					input type: "email", class: "form-control", placeholder: "email address", autocomplete: "on", name: "email", required: true

				-- div class: "row", -> div class: "g-recaptcha", ["data-sitekey"]: "6LeurhMTAAAAAPwfyNazLGDYL-sqi6e2_b1aaC0Y"

				div class: "row", -> div class: "col-md-4 col-md-offset-4", ->
					button type: "submit", class: "form-control btn btn-default", "register"