import Widget from require "lapis.html"
i18n = require "i18n"

-- This is the login form that is used throughout the website
-- It can be used in the fixed position "popover" login as well as
-- in the dedicated /login page
class LoginForm extends Widget
	@include "widgets.utils"
	
	content: =>
		form id: "mta-login-form", method: "POST", action: @url_for("auth.login"), ->
			-- csrf token to prevent cross-side-request-forgery
			@write_csrf_input!
			
			with route = @params.return_to
				-- if we don't have to return anywhere...
				unless route
					-- if the route we're on is login, go home, or go to the current page
					route = (@route_name == "auth.login") and (@url_for "home") or @req.parsed_url.path
				
				input type: "hidden", name: "return_to", value: route, ["aria-hidden"]: "true"

			div class: "input-group", ->
				span class: "input-group-addon", -> i class: "fa fa-fw fa-user"
				input
					type: "text"
					id: "mta-widget-login-username"
					class: "form-control"
					placeholder: i18n "auth.username_placeholder"
					autocomplete: "on"
					name: "username"
					value: @params.username
					required: true

			div class: "input-group", ->
				span class: "input-group-addon", -> i class: "fa fa-fw fa-key"
				input
					type: "password"
					class: "form-control"
					placeholder: i18n "auth.password_placeholder"
					autocomplete: "on"
					name: "password"
					required: true
			
			row class: "no-gutter", ->
				div class: "col-md-4", ->
					a href: @url_for("auth.forgot"), class: "btn btn-secondary pull-left", -> i class: "fa fa-fw fa-question"
				
				div class: "col-md-8", ->
					div class: "input-group", ->
						--span class: "input-group-addon", -> input type: "checkbox", name: "remember", value: "true"
						button type: "submit", class: "form-control btn btn-secondary", i18n "auth.login_button"
