import Widget from require "lapis.html"

-- This is the widget for the search card used on the
-- resources listing page and the search results page
class SearchCard extends Widget
	@include "widgets.utils"

	content: =>
		div class: "card", id: "mta-search-widget", ->
			div class: "card-header", ->
				text " Search"
				unless @onSearchPage
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
						@write_csrf_input!
						button type: "submit", class: "btn btn-primary btn-sm pull-xs-right", -> i class: "fa fa-search"

			div class: {"card-block", ["collapse"]: not @onSearchPage}, id: "advancedSearch", ->
				form action: @url_for("search"), method: "POST", class: "form-inline form-control-sm mta-search-form", ->
					div class: "row", ->
						@form_group_name true
						text " "
						@form_group_type true
						text " "
						div class: "checkbox", ->
    						label ->
    							input type: "checkbox", name: "description", value: "true", checked: @params.description
    							text " Search in description"

					div class: "row", ->
						div class: "form-group", ->
							label class: "sr-only", ["for"]: "searchAuthor", "Author"
							input type: "text", class: "form-control", name: "author", id: "searchAuthor", placeholder: "author", value: @params.author
						text " "
						div class: "form-group", ->
							label class: "sr-only", ["for"]: "searchShowAmount", "Show (1 - 100)"
							input type: "number", class: "form-control", name: "showAmount", id: "searchShowAmount", min: "1", max: "100", placeholder: "show (1 - 100)", value: @params.showAmount

						@write_csrf_input!
						button type: "submit", class: "btn btn-primary btn-sm pull-xs-right", ->
							i class: "fa fa-search"
							text " Search"

	-- Snippet for creating the "name" form group
	form_group_name: (advancedMode) =>
		div class: "form-group", ->
			label class: "sr-only", ["for"]: "searchGreedyName", "Name"
			text " " if advancedMode
			input 
				type: "text"
				class: {"form-control", ["form-control-sm"]: not advancedMode}
				name: "name"
				id: "searchGreedyName"
				placeholder: "short or long name"
				required: not advancedMode
				value: @params.name

	-- Snippet for creating the "type" form group
	form_group_type: (advancedMode) =>
		div class: "form-group", ->
			label class: "sr-only", ["for"]: "searchType", "Type"
			element "select", name: "type", class: {"form-control", ["form-control-sm"]: not advancedMode, "c-select"}, ->
				option value: "any", selected: not @params.type, "any type"
				for opt in *{"script", "map", "gamemode", "misc"}
					option selected: @params.type == opt, opt