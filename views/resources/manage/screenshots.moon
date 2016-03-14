import Widget from require "lapis.html"
import ResourceScreenshots from require "models"
date = require "date"
db = require "lapis.db"

class MTAResourceManageScreenies extends Widget
	@include "widgets.utils"

	name: "Screenshots"
	content: =>
		p -> button type: "button", class: "btn btn-primary", ["data-toggle"]: "collapse", ["data-target"]: "#upload", ["aria-expanded"]: "false", ["aria-controls"]: "upload", ->
			i class: "fa fa-chevron-circle-down"
			text " Upload screenshot"
	
		div class: "collapse", id: "upload", ->
			div class: "card card-block", ->
				form method: "POST", enctype: "multipart/form-data", ->
					@write_csrf_input!
					fieldset class: "form-group", ->
						label for: "screenieTitle", ->
							text "Title "
							small class: "text-muted", "Summarise your screenshot"
						input type: "text", class: "form-control", id: "screenieTitle", name: "screenieTitle", required: true

					fieldset class: "form-group", ->
						label for: "screenieDescription", ->
							text "Description "
							small class: "text-muted", "optional"
						textarea class: "form-control", id: "screenieDescription", name: "screenieDescription", rows: 3

					input type: "file", id: "uploadScreenieFile", required: true
					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-upload"
						text " Upload screenshot"


		div class: "card", ->
			div class: "card-header", ->
				text "Screenshots"
			div class: "card-block", ->
				element "table", class: "table table-hover table-bordered table-href mta-card-table", ->
					thead ->
						th "Title"
						th "Creation Date"
					tbody ->
						screenshots = ResourceScreenshots\select "where resource = ? order by created_at desc", @resource.id, fields: "id, title, created_at"
						for screenshot in *screenshots
							manage_url = @url_for("resources.manage.view_screenshot", resource_slug: @resource, screenie_id: screenshot.id)
							tr ["data-href"]: manage_url, ->
								td screenshot.title
								td ->
									date(screenshot.created_at)\fmt "${http}"
									a href: manage_url, class: "btn btn-sm btn-secondary pull-xs-right", -> i class: "fa fa-cogs"