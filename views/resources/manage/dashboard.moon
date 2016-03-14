import Widget from require "lapis.html"
import Comments, ResourceScreenshots from require "models"
db = require "lapis.db"

class MTAResourceManageDashboard extends Widget
	@include "widgets.utils"

	name: "Dashboard"
	content: =>
		div class: "card", ->
			div class: "card-header", "Statistics"
			div class: "card-block", ->
				text "Downloads: #{@resource.downloads}"
				br!
				text "Screenshots: " .. tostring(ResourceScreenshots\count "resource = ?", @resource.id)

				num_parent_comments = Comments\count "(resource = ?) and (parent IS NULL)", @resource.id
				num_total_comments = Comments\count "resource = ?", @resource.id

				div ->
					text "Comments - #{num_total_comments}"
					ul ->
						li "Parent comments: #{num_parent_comments}"
						li "Comment replies: #{num_total_comments - num_parent_comments}"

				div ->
					depended_on = db.select [[
						DISTINCT ON (resources.id) resources.name, resources.slug
			  
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
						text "This resource is not included by any other resource."
					else
						text "This resource is included by: "
						ul ->
							for row in *depended_on
								li -> a href: @url_for("resources.view", resource_slug: row.slug), row.name