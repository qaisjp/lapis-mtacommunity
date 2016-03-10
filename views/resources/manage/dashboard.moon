import Widget from require "lapis.html"
db = require "lapis.db"

class MTAResourceManageDashboard extends Widget
	@include "widgets.utils"

	name: "Dashboard"
	content: =>
		div class: "card", ->
			div class: "card-header", "Statistics"
			div class: "card-block", ->
				p "Downloads: #{@resource.downloads}"


				depended_on = db.select [[
					DISTINCT ON (resources.id) resources.name
		  
		  			FROM (
		  
						SELECT DISTINCT ON (resource_packages.id) resource_packages.id as package_id
			  			FROM resources, package_dependencies, resource_packages
			  
			  			WHERE package_dependencies.package = resource_packages.id
						AND resource_packages.resource = ?
		  
		  			) as sub, resource_packages, package_dependencies, resources 

		  			WHERE package_dependencies.package = package_id
		  
					AND resources.id = resource_packages.resource
					AND package_dependencies.source_package = resource_packages.id
				]], @resource.id

				if #depended_on == 0
					p "This resource is not included by any other resource."
				else
					p "This resource is included by: "
					ul ->
						for row in *depended_on
							li row.name