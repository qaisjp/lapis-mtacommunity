import Widget from require "lapis.html"
import write_csrf_input from require "utils"

-- This is the login form that is used throughout the website
-- It can be used in the fixed position "popover" login as well as
-- in the dedicated /login page
class LoginForm extends Widget
	@include "widgets.utils"
	
	content: =>
		form id: "mta-login-form", method: "POST", action: @url_for("auth.login"), ->
			-- csrf token to prevent cross-side-request-forgery (who would've guessed?)
			@write_csrf_input!

			div class: "input-group", ->
				span class: "input-group-addon", -> i class: "fa fa-fw fa-user"
				input type: "text", class: "form-control", placeholder: "username", autocomplete: "on", name: "username", value: @params.username, required: true

			div class: "input-group", ->
				span class: "input-group-addon", -> i class: "fa fa-fw fa-key"
				input type: "password", class: "form-control", placeholder: "password", autocomplete: "on", name: "password", required: true
			
			row class: "no-gutter", ->
				div class: "col-md-4", ->
					button type: "button", class: "btn btn-default pull-left", -> i class: "fa fa-fw fa-question"
				
				div class: "col-md-8", ->
					div class: "input-group", ->
						span class: "input-group-addon", -> input type: "checkbox", name: "remember", value: "true"
						button type: "submit", class: "form-control btn btn-default", "login"