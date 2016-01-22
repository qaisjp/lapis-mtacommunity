import Widget from require "lapis.html"

-- This is the widget for the search card used on the
-- resources listing page and the search results page
class SearchCard extends Widget
	@include "widgets.utils"

	content: =>
		div class: "card mta-resources-search", ->
			div class: "card-header", ->
				a class: "btn btn-secondary btn-sm", role: "button", ["data-toggle"]: "collapse", href: "#advancedSearch", ["aria-expanded"]:"false", ["aria-controls"]: "advancedSearch", ->
					i class: "fa fa-cogs"
				text " Search"
				text " "
				form action: @url_for("search"), type: "GET", class: "mta-inline-form form-inline", ->
					div class: "form-group", ->
						label class: "sr-only", ["for"]: "searchGreedyName", "Name"
						text " "
						input type: "text", class: "form-control", name: "greedyName", id: "searchGreedyName", placeholder: "short or long name"
					text " "
					div class: "form-group", ->
						element "select", name: "type", class: "c-select", ->
							option selected: true, "any type"
							option "script"
							option "map"
							option "gamemode"
							option "misc"
					button type: "submit", class: "btn btn-primary btn-sm pull-xs-right", -> i class: "fa fa-search"
			div class: "card-block collapse", id: "advancedSearch", -> "Search Contents"