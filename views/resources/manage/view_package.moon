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

			div class: "card-block", ->
				-- VIEW INCLUDED RESOURCES
				depended_on = db.select [[
					DISTINCT ON (resources.id) resources.name, resources.slug, resource_packages.version
		  
		  			FROM (
		  
						SELECT DISTINCT ON (resource_packages.id) resource_packages.id as package_id
			  			FROM resources, package_dependencies, resource_packages
			  
			  			WHERE package_dependencies.source_package = ?
		  
		  			) as sub, resource_packages, package_dependencies, resources 

		  			WHERE package_dependencies.source_package = package_id
					AND resources.id = resource_packages.resource
					AND resources.id <> ?
					AND package_dependencies.source_package = resource_packages.id
				]], @package.id, @resource.id

				if #depended_on == 0
					text i18n "resources.manage.packages.not_including"
				else
					text i18n "resources.manage.packages.is_including"
					ul ->
						for row in *depended_on
							li ->
								a href: @url_for("resources.view", resource_slug: row.slug), row.name
								text " v#{row.version}"

					p i18n "resources.manage.packages.include_add"
					form method: "GET", class: "mta-inline-form form-inline", ->
						@write_csrf_input!
						input class: "form-control", name: "include_resource", required: true, placeholder: i18n("resources.manage.packages.include_resource"), value: @params.include_resource
						input class: "form-control", name: "include_version", placeholder: i18n("resources.manage.packages.include_version"), value: @params.include_version

						button type: "submit", name: "addInclude", value: "true", class: "btn btn-secondary btn-sm", ->
							text i18n "resources.manage.packages.include_button"