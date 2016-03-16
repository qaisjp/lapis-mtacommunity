import Widget from require "lapis.html"
import ResourcePackages from require "models"
date = require "date"
db = require "lapis.db"
i18n = require "i18n"

class MTAResourceManageSinglePackage extends Widget
	@include "widgets.utils"

	name: "Screenshots"
	content: =>
		div class: "card", ->
			div class: "card-header", ->
				text "#{i18n 'resources.manage.title'} #{@screenshot.id}"
			div class: "card-block", ->
				form method: "POST", class: "mta-inline-form", ->
					@write_csrf_input!
					fieldset class: "form-group", ->
						label for: "screenieTitle", ->
							text "#{i18n 'resources.manage.screenshots.title'} "
							small class: "text-muted", i18n "resources.manage.screenshots.title_info"
						input type: "text", class: "form-control", id: "screenieTitle", name: "screenieTitle", value: @screenshot.title
					fieldset class: "form-group", ->
						label for: "screenieDescription", ->
							text "#{i18n 'resources.manage.screenshots.description'} "
							small class: "text-muted", i18n 'resources.manage.screenshots.optional'
						textarea class: "form-control", id: "screenieDescription", name: "screenieDescription", rows: 3, @screenshot.description

					a href: @url_for("resources.view_screenshot", resource_slug: @resource, screenie_id: @screenshot.id), class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-globe"
						text " #{i18n 'view'}"
					
					raw " "

					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-pencil"
						text " #{i18n 'update'}"
					
					raw " "
					
					button type: "submit", name: "deleteScreenie", formnovalidate: true, class: "btn btn-secondary btn-danger btn-sm", ->
						i class: "fa fa-remove"
						text " #{i18n 'delete'}"

				