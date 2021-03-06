import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"
i18n = require "i18n"

class MTAResourcesOverview extends Widget
	content: =>
		h1 ->
			text i18n "resources.title"
			if @active_user
				a href: @url_for("resources.upload"), class: "btn btn-secondary pull-xs-right" , ->
					i class: "fa fa-upload"
					raw " "
					text i18n "resources.manage.packages.upload"

		div class: "container", ->
			div class: "row", ->
				widget require "widgets.search"

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", i18n "resources.overview.most_downloaded"
					div class: "card-block", ->
						element "table", class: "table table-hover table-href table-bordered mta-card-table", ->
							thead -> tr ->
								th i18n "resources.table.name"
								th i18n "resources.table.description"
								th i18n "resources.table.downloads"
							tbody ->
								-- Get the top 15 downloaded resource instances
								resourceList = Resources\select "ORDER BY downloads DESC LIMIT 15"
								for resource in *resourceList
									tr ["data-href"]: (@url_for "resources.view", resource_slug: resource.slug), ->
										td ->
											text "#{resource.longname} (#{resource.name}) "
											span class: "label label-info", Resources.types[resource.type]
										td resource.description
										td resource.downloads

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", i18n "resources.overview.best_resources"
					div class: "card-block", ->
						element "table", class: "table table-hover table-href table-bordered mta-card-table", ->
							thead -> tr ->
								th i18n "resources.table.name"
								th i18n "resources.table.description"
								th i18n "resources.table.rating"
							tbody ->
								-- Get the top 15 rated resource instances
								resourceList = Resources\select "ORDER BY rating DESC LIMIT 15"
								for resource in *resourceList
									tr ["data-href"]: (@url_for "resources.view", resource_slug: resource.slug), ->
										td ->
											text "#{resource.longname} (#{resource.name}) "
											span class: "label label-info", Resources.types[resource.type]
										td resource.description
										td resource.rating

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", i18n "resources.overview.recently_uploaded"
					div class: "card-block", ->
						element "table", class: "table table-hover table-href table-bordered mta-card-table", ->
							thead -> tr ->
								th i18n "resources.table.name"
								th i18n "resources.table.version"
								th i18n "resources.table.publish_date"
							tbody ->
								-- Get the recent uploaded resource instances
								packageList = ResourcePackages\select "ORDER BY created_at DESC LIMIT 15"
								Resources\include_in packageList, "resource", as: "resource"

								for package in *packageList
									resource = package.resource
									tr ["data-href"]: (@url_for "resources.view", resource_slug: resource.slug), ->
										td ->
											text "#{resource.longname} (#{resource.name}) "
											span class: "label label-info", Resources.types[resource.type]
										td package.version
										td time_ago_in_words package.created_at, 2
