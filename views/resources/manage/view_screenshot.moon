import Widget from require "lapis.html"
import ResourcePackages from require "models"
date = require "date"
db = require "lapis.db"

class MTAResourceManageSinglePackage extends Widget
	@include "widgets.utils"

	name: "Screenshots"
	content: =>
		div class: "card", ->
			div class: "card-header", ->
				text "Managing screenshot #{@screenshot.id}"
			div class: "card-block", ->
				form method: "POST", class: "mta-inline-form", ->
					@write_csrf_input!
					fieldset class: "form-group", ->
						label for: "screenieTitle", ->
							text "Title "
							small class: "text-muted", "Summarise your screenshot"
						input type: "text", class: "form-control", id: "screenieTitle", name: "screenieTitle", required: true, value: @screenshot.title
					fieldset class: "form-group", ->
						label for: "updateDescription", ->
							text "Description "
							small class: "text-muted", "optional"
						textarea class: "form-control", id: "updateDescription", name: "updateDescription", rows: 3, @screenshot.description

					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-pencil"
						text " Update"

				raw " "
				--a href: @url_for("resources.get", resource_slug: @resource), class: "btn btn-secondary btn-sm", ->
				--	i class: "fa fa-download"
				--	text " View"