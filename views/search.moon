import Widget from require "lapis.html"
import Resources from require "models"
SearchWidget = require("widgets.search")
i18n = require "i18n"

class Search extends Widget
	content: =>
		widget SearchWidget onSearchPage: true

		-- Show an empty advanced page if not searched..
		return unless @resourceList
	
		div class: "card", ->
			div class: "card-header", ->
				text i18n "search.results_header"
				a href: @url_for("search", nil, @params), class: "btn btn-sm btn-primary pull-xs-right", -> i class: "fa fa-link"
			div class: "card-block", ->
				if #@resourceList > 0
					element "table", class: "table table-hover table-bordered table-href mta-card-table", ->
						thead -> tr ->
							th i18n "resources.table.name"
							th i18n "resources.table.description"
							th i18n "resources.table.rating"
						tbody ->
							for resource in *@resourceList
								tr ["data-href"]: (@url_for "resources.view", resource_slug: resource.slug), ->
									td ->
										text "#{resource.longname} (#{resource.name}) "
										span class: "label label-info", Resources.types\to_name resource.type
									td resource.description
									td resource.rating
				else
					small i18n "search.no_results"
						