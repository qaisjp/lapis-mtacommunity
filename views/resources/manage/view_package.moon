import Widget from require "lapis.html"
import ResourcePackages from require "models"
date = require "date"
db = require "lapis.db"

class MTAResourceManageSinglePackage extends Widget
	@include "widgets.utils"

	name: "Packages"
	content: =>
		div class: "card", ->
			div class: "card-header", ->
				text "Managing v#{@package.version}"
			div class: "card-block", ->
				form method: "POST", class: "mta-inline-form", ->
					fieldset class: "form-group", ->
						label for: "updateDescription", ->
							text "Description "
							small class: "text-muted", "What does this update do? What has changed?"
						textarea class: "form-control", id: "updateDescription", name: "updateDescription", rows: 3, required: true, @package.description

					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-pencil"
						text " Update"

				raw " "
				a href: @url_for("resources.get", resource_slug: @resource, version: @package.version), class: "btn btn-secondary btn-sm", ->
					i class: "fa fa-download"
					text " Download"