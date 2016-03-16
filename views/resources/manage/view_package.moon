import Widget from require "lapis.html"
import ResourcePackages from require "models"
date = require "date"
db = require "lapis.db"
i18n = require "i18n"

class MTAResourceManageSinglePackage extends Widget
	@include "widgets.utils"

	name: "Packages"
	content: =>
		div class: "card", ->
			div class: "card-header", ->
				text "#{i18n 'resources.manage.title'} v#{@package.version}"
			div class: "card-block", ->
				form method: "POST", class: "mta-inline-form", ->
					@write_csrf_input!
					fieldset class: "form-group", ->
						label for: "updateDescription", ->
							text "#{i18n 'resources.manage.packages.description'} "
							small class: "text-muted", i18n "resources.manage.packages.description_info"
						textarea class: "form-control", id: "updateDescription", name: "updateDescription", rows: 3, required: true, @package.description

					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-pencil"
						text " #{i18n 'update'}"

				raw " "
				a href: @url_for("resources.get", resource_slug: @resource, version: @package.version), class: "btn btn-secondary btn-sm", ->
					i class: "fa fa-download"
					text " #{i18n 'download'}"