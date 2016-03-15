import Widget from require "lapis.html"
i18n = require "i18n"
class MTASettingsAccount extends Widget
	@include "widgets.utils"

	category: "account"
	content: =>
		div class: "card", ->
			div class: "card-header", i18n "settings.changepass_title"
			div class: "card-block", -> form action: @url_for("settings.change_password"), method: "POST", ->
				@write_csrf_input!

				div class: "form-group row", ->
					label class: "col-sm-2", i18n "settings.changepass_title"
					div class: "col-sm-10", ->
						input type: "password", class: "form-control", name: "settingsOldPassword"

				div class: "form-group row", ->
					label class: "col-sm-2", i18n "settings.new_pass"
					div class: "col-sm-10", ->
						input type: "password", class: "form-control", name: "settingsNewPassword"

				div class: "form-group row", ->
					label class: "col-sm-2", i18n "settings.confirm_new_pass"
					div class: "col-sm-10", ->
						input type: "password", class: "form-control", name: "settingsNewPasswordConfirm"

				div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", i18n "settings.changepass_button"

		div class: "card", ->
			div class: "card-header", i18n "settings.rename_title"
			div class: "card-block", -> form action: @url_for("settings.rename_account"), method: "POST", ->
				@write_csrf_input!

				p i18n "settings.rename_info"
				div class: "form-group row", ->
					label class: "col-sm-2", i18n "settings.username"
					div class: "col-sm-10", ->
						input type: "text", class: "form-control", name: "settingsNewUsername", value: @active_user.username

				div class: "form-group row", ->
					div class: "col-sm-offset-2 col-sm-10", ->
						button type: "submit", class: "btn btn-secondary", onclick: "return confirm(\"#{i18n 'settings.rename_confirm'}\")", i18n "settings.rename_button"

		div class: "card", ->
			div class: "card-header bg-danger", "Delete account"
			div class: "card-block", ->
				p i18n "settings.delete_info"

				form action: @url_for("settings.delete_account"), method: "POST", ->
					@write_csrf_input!
					button class: "btn btn-primary btn-danger", type: "submit", onclick: "return confirm(\"#{i18n 'settings.delete_confirm'}\")", i18n "settings.delete_button"
				
