import Widget from require "lapis.html"
i18n = require "i18n"

class MTAResourceManageSettings extends Widget
	@include "widgets.utils"

	name: "Settings"
	content: =>
		div class: "card", ->
			div class: "card-header", i18n "resources.manage.settings.transfer_ownership"
			div class: "card-block", -> form action: @url_for("resources.manage.transfer_ownership", resource_slug: @resource), method: "POST", ->
				@write_csrf_input!

				p i18n "resources.manage.settings.transfer_ownership_info"
				fieldset class: "form-group row", ->
					label class: "col-sm-2", for: "settingsNewOwner", i18n "resources.manage.settings.new_owner"
					div class: "col-sm-10", ->
						input type: "text", class: "form-control", id: "settingsNewOwner", name: "settingsNewOwner", required: true

				div class: "form-group row", ->
					div class: "col-sm-offset-2 col-sm-10", ->
						button type: "submit", class: "btn btn-secondary", onclick: "return confirm(\"#{i18n 'resources.manage.settings.transfer_ownership_confirm'}\")", "#{i18n 'resources.manage.settings.transfer_ownership'}..."

		div class: "card", ->
			div class: "card-header", i18n "resources.manage.settings.rename_resource"
			div class: "card-block", -> form action: @url_for("resources.manage.rename", resource_slug: @resource), method: "POST", ->
				@write_csrf_input!

				p i18n "resources.manage.settings.rename_info_first"
				p i18n "resources.manage.settings.rename_info_second"
				p i18n "resources.manage.settings.rename_info_third"

				fieldset class: "form-group row", ->
					label class: "col-sm-2", for: "settingsNewResourceName", i18n "resources.manage.settings.rename_name"
					div class: "col-sm-10", ->
						input type: "text", class: "form-control", name: "settingsNewResourceName", id: "settingsNewResourceName", value: @resource.name, required: true

				div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", onclick: "return confirm(\"#{i18n 'resources.manage.settings.rename_confirm'}\")", i18n "resources.manage.settings.rename_button"

		div class: "card", ->
			div class: "card-header bg-danger", i18n "resources.manage.settings.delete"
			div class: "card-block", ->
				p i18n "resources.manage.settings.delete_info"

				form action: @url_for("resources.manage.delete", resource_slug: @resource), method: "POST", ->
					@write_csrf_input!
					button class: "btn btn-primary btn-danger", type: "submit", onclick: "return confirm(\"#{i18n 'resources.manage.settings.delete_confirm'}\")", i18n "resources.manage.settings.delete_button"
