import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import time_ago, time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcesOverview extends Widget
	content: =>
		h1 "Resources"

		div class: "container", ->
			div class: "row", ->
				widget require "widgets.search"

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", "Most Downloaded"
					div class: "card-block", ->
						element "table", class: "table table-hover table-href table-bordered mta-resources-table", ->
							thead -> tr ->
								th "Name"
								th "Description"
								th "Downloads"
							tbody ->
								-- Get the top 15 downloaded resource instances
								resourceList = Resources\select "ORDER BY downloads DESC LIMIT 15"
								for resource in *resourceList
									tr ["data-href"]: (@url_for "resources.view", resource_name: resource.slug), ->
										td ->
											text "#{resource.longname} (#{resource.name}) "
											span class: "label label-info", Resources.types[resource.type]
										td resource.description
										td resource.downloads

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", "Best Resources"
					div class: "card-block", ->
						element "table", class: "table table-hover table-href table-bordered mta-resources-table", ->
							thead -> tr ->
								th "Name"
								th "Description"
								th "Downloads"
							tbody ->
								-- Get the top 15 rated resource instances
								resourceList = Resources\select "ORDER BY rating DESC LIMIT 15"
								for resource in *resourceList
									tr ["data-href"]: (@url_for "resources.view", resource_name: resource.slug), ->
										td ->
											text "#{resource.longname} (#{resource.name}) "
											span class: "label label-info", Resources.types[resource.type]
										td resource.description
										td resource.downloads

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", "Recently Uploaded"
					div class: "card-block", ->
						element "table", class: "table table-hover table-href table-bordered mta-resources-table", ->
							thead -> tr ->
								th "Name"
								th "Version"
								th "Date Updated"
							tbody ->
								-- Get the top 15 rated resource instances
								packageList = ResourcePackages\select "ORDER BY created_at DESC LIMIT 15"
								Resources\include_in packageList, "resource", as: "resource"

								for package in *packageList
									resource = package.resource
									tr ["data-href"]: (@url_for "resources.view", resource_name: resource.slug), ->
										td ->
											text "#{resource.longname} (#{resource.name}) "
											span class: "label label-info", Resources.types[resource.type]
										td package.version
										td time_ago_in_words package.created_at, 2