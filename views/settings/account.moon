import Widget from require "lapis.html"

class MTASettingsAccount extends Widget
	@include "widgets.utils"

	name: "Account"
	content: =>
		div class: "card", ->
			div class: "card-header", "Change password"
			div class: "card-block", -> form action: @url_for("settings.change_password"), method: "POST", ->
				@write_csrf_input!

				div class: "form-group row", ->
					label class: "col-sm-2", "Old password"
					div class: "col-sm-10", ->
						input type: "password", class: "form-control", name: "settingsOldPassword"

				div class: "form-group row", ->
					label class: "col-sm-2", "New password"
					div class: "col-sm-10", ->
						input type: "password", class: "form-control", name: "settingsNewPassword"

				div class: "form-group row", ->
					label class: "col-sm-2", "Confirm new password"
					div class: "col-sm-10", ->
						input type: "password", class: "form-control", name: "settingsNewPasswordConfirm"

				div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", "Change password"

		div class: "card", ->
			div class: "card-header", "Change username"
			div class: "card-block", -> form action: @url_for("settings.rename_account"), method: "POST", ->
				@write_csrf_input!

				p "Your old username also becomes available for other people to register. No redirections will be set up."
				div class: "form-group row", ->
					label class: "col-sm-2", "Username"
					div class: "col-sm-10", ->
						input type: "text", class: "form-control", name: "settingsNewUsername", value: @active_user.username

				div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", onclick: "return confirm('Are you sure you want to change your username?')", "Change username..."

		div class: "card", ->
			div class: "card-header bg-danger", "Delete account"
			div class: "card-block", ->
				p "Deleting your account removes all resources, names from your comments, and screenshots. The username also becomes available for other people to register."

				form action: @url_for("settings.delete_account"), method: "POST", ->
					@write_csrf_input!

					button class: "btn btn-primary btn-danger", type: "submit", onclick: "return confirm('Are you sure you want to delete your account? This is permanent.')", " Delete account..."
				
