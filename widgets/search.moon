import Widget from require "lapis.html"

-- This is the widget for the search card used on the
-- resources listing page and the search results page
class SearchCard extends Widget
	@include "widgets.utils"

	content: =>
		div class: "card mta-resources-search", ->
			div class: "card-header", ->
				text " Search"
				text " "
				form action: @url_for("search"), method: "POST", class: "mta-inline-form form-inline mta-search-form", ->
					@form_group_name!
					text " "
					@form_group_type!
					a {
						class: "btn btn-secondary btn-sm pull-xs-right", role: "button",
						["data-toggle"]: "collapse", href: "#advancedSearch",
						["aria-expanded"]: "false", ["aria-controls"]: "advancedSearch"
					}, -> i class: "fa fa-cogs"
					button type: "submit", class: "btn btn-primary btn-sm pull-xs-right", -> i class: "fa fa-search"

			div class: "card-block collapse", id: "advancedSearch", ->
				form action: @url_for("search"), method: "POST", class: "form-inline form-control-sm mta-search-form", ->
					div class: "row", ->
						@form_group_name true
						text " "
						@form_group_type true
						text " "
						div class: "form-group", ->
								label class: "sr-only", ["for"]: "searchDescription", "Description"
								input type: "text", class: "form-control", name: "description", id: "searchDescription", placeholder: "description"

					div class: "row", ->
						div class: "form-group", ->
							label class: "sr-only", ["for"]: "searchAuthor", "Author"
							input type: "text", class: "form-control", name: "author", id: "searchAuthor", placeholder: "author"
						text " "
						div class: "form-group", ->
							label class: "sr-only", ["for"]: "searchShowAmount", "Show (1 - 100)"
							input type: "text", class: "form-control", name: "showAmount", id: "searchShowAmount", placeholder: "show (1 - 100)"

						button type: "submit", class: "btn btn-primary btn-sm pull-xs-right", ->
							i class: "fa fa-search"
							text " Search"

	-- Snippet for creating the "name" form group
	form_group_name: (advancedMode) =>
		div class: "form-group", ->
			label class: "sr-only", ["for"]: "searchGreedyName", "Name"
			text " " if advancedMode
			input type: "text", class: {"form-control", ["form-control-sm"]: not advancedMode}, name: "greedyName", id: "searchGreedyName", placeholder: "short or long name", required: not advancedMode

	-- Snippet for creating the "type" form group
	form_group_type: (advancedMode) =>
		div class: "form-group", ->
			label class: "sr-only", ["for"]: "searchType", "Type"
			element "select", name: "type", class: {"form-control", ["form-control-sm"]: not advancedMode, "c-select"}, ->
				option value: "", selected: true, "any type"
				option "script"
				option "map"
				option "gamemode"
				option "misc"