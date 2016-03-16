import Widget from require "lapis.html"
import write_csrf_input from require "utils"
i18n = require "i18n"

class AuthForgot extends Widget
	@include "widgets.utils"
	
	content: =>
	
		h1 i18n "auth.reset_title"
		div class: "col-md-6", ->
			if @errors
				@output_errors!
			elseif @success
				div class: "alert alert-success", role: "alert", i18n "auth.reset_email_sent"
			
			form id: "mta-register-form", method: "POST", ->
				-- csrf token to prevent cross-side-request-forgery (who would've guessed?)
				@write_csrf_input!

				if @params.splat
					input type: "password", class: "form-control", name: "password", placeholder: i18n "settings.new_pass", required: true
					input type: "password", class: "form-control", name: "password_confirm", placeholder: i18n "settings.confirm_new_pass", required: true
					
					button type: "submit", class: "form-control btn btn-primary", i18n("settings.changepass_button")
				else
					div class: "input-group", ->
						span class: "input-group-addon", -> i class: "fa fa-fw fa-envelope"
						input type: "email", class: "form-control", placeholder: i18n("auth.email_placeholder"), autocomplete: "on", name: "email", required: true, value: @params.email
					
					button type: "submit", class: "form-control btn btn-primary", i18n("auth.reset_send_email")
					