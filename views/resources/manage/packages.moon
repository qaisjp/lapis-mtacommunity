import Widget from require "lapis.html"
import ResourcePackages from require "models"
date = require "date"
db = require "lapis.db"
i18n = require "i18n"

class MTAResourceManagePackages extends Widget
	@include "widgets.utils"

	name: "Packages"
	content: =>
		has_errors = @errors != nil
		if has_errors and (#@errors == 0)
			has_errors = nil
			div class: "alert alert-success", role: "alert", ->
				strong ->
					text i18n "success"
					raw " "
				text i18n "resources.manage.packages.upload_success"

		p -> button type: "button", class: "btn btn-primary", ["data-toggle"]: "collapse", ["data-target"]: "#upload", ["aria-expanded"]: has_errors, ["aria-controls"]: "upload", ->
			i class: "fa fa-chevron-circle-down"
			text " #{i18n 'resources.manage.packages.update_resource'}"
	
		div class: {"collapse", in: has_errors}, id: "upload", ->
			div class: "card card-block", ->
				@output_errors!
				form method: "POST", enctype: "multipart/form-data", ->
					@write_csrf_input!
					fieldset class: "form-group", ->
						label for: "uploadChangelog", ->
							text "#{i18n 'resources.manage.packages.changelog'} "
							small class: "text-muted", i18n "resources.manage.packages.changelog_info"
						textarea class: "form-control", id: "uploadChangelog", name: "uploadChangelog", rows: 3, required: true, @params.uploadChangelog

					input type: "file", name: "uploadFile", required: true
					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-upload"
						text " #{i18n 'resources.manage.packages.upload'}"


		div class: "card", ->
			div class: "card-header", ->
				text "Packages"
			div class: "card-block", ->
				element "table", class: "table table-hover table-bordered table-href mta-card-table", ->
					thead ->
						th i18n "resources.table.version"
						th i18n "resources.table.publish_date"
						th i18n "resources.table.changes"
					tbody ->
						packages = ResourcePackages\select "where resource = ? order by version desc", @resource.id, fields: "id, version, description, created_at"
						for package in *packages
							manage_url = @url_for("resources.manage.view_package", resource_slug: @resource, pkg_id: package.id)
							tr ["data-href"]: manage_url, ->
								td package.version
								td date(package.created_at)\fmt "${http}"
								td ->
									text package.description
									a href: manage_url, class: "btn btn-sm btn-secondary pull-xs-right", -> i class: "fa fa-cogs"