import Widget from require "lapis.html"
import ResourceScreenshots from require "models"
date = require "date"
db = require "lapis.db"
i18n = require "i18n"

class MTAResourceManageScreenies extends Widget
	@include "widgets.utils"

	name: "Screenshots"
	content: =>
		p -> button type: "button", class: "btn btn-primary", ["data-toggle"]: "collapse", ["data-target"]: "#upload", ["aria-expanded"]: "false", ["aria-controls"]: "upload", ->
			i class: "fa fa-chevron-circle-down"
			raw " "
			text i18n "resources.manage.screenshots.upload"
	
		div class: "collapse", id: "upload", ->
			div class: "card card-block", ->
				form method: "POST", enctype: "multipart/form-data", ->
					@write_csrf_input!
					fieldset class: "form-group", ->
						label for: "screenieTitle", ->
							text "#{i18n 'resources.manage.screenshots.title'} "
							small class: "text-muted", i18n "resources.manage.screenshots.title_info"
						input type: "text", class: "form-control", id: "screenieTitle", name: "screenieTitle", required: true

					fieldset class: "form-group", ->
						label for: "screenieDescription", ->
							text "#{i18n 'resources.manage.screenshots.description'} "
							small class: "text-muted", i18n "resources.manage.screenshots.optional"
						textarea class: "form-control", id: "screenieDescription", name: "screenieDescription", rows: 3

					input type: "file", name: "screenieFile", required: true
					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-upload"
						text " #{i18n 'resources.manage.packages.upload'}"


		div class: "card", ->
			div class: "card-header", ->
				text i18n "resources.manage.tab_screenshots"
			div class: "card-block", ->
				screenshots = ResourceScreenshots\select "where resource = ? order by created_at desc", @resource.id, fields: "id, title, created_at"
				if #screenshots == 0
					return p i18n "resources.manage.screenshots.none_uploaded"
				element "table", class: "table table-hover table-bordered table-href mta-card-table", ->
					thead ->
						th i18n "resources.table.title"
						th i18n "resources.table.publish_date"
					tbody ->
						for screenshot in *screenshots
							manage_url = @url_for("resources.manage.view_screenshot", resource_slug: @resource, screenie_id: screenshot.id)
							view_url = @url_for("resources.view_screenshot", resource_slug: @resource, screenie_id: screenshot.id)
							tr ["data-href"]: manage_url, ->
								td screenshot.title
								td ->
									text date(screenshot.created_at)\fmt "${http}"
									div class: "pull-xs-right", ->
										a href: view_url  , class: "btn btn-sm btn-secondary", -> i class: "fa fa-globe"
										raw " "
										a href: manage_url, class: "btn btn-sm btn-secondary", -> i class: "fa fa-cogs"