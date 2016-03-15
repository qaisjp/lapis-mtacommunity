import Widget from require "lapis.html"
i18n = require "i18n"

-- This is the widget for the search card used on the
-- resources listing page and the search results page
class SearchCard extends Widget
	@include "widgets.utils"

	content: =>
		div class: "card", id: "mta-search-widget", ->
			div class: "card-header", ->
				text " #{i18n 'search.title'}"

				-- We won't show the quick search fields if we're on the search page
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

						button type: "submit", class: "btn btn-primary btn-sm pull-xs-right", -> i class: "fa fa-search"

			-- "collapse": we want the full thing to show when we're on the search page
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
    							text " #{i18n 'search.in_description'}"

					div class: "row", ->
						div class: "form-group", ->
							label class: "sr-only", ["for"]: "searchAuthor", "Author"
							input
								type: "text", class: "form-control",
								name: "author", id: "searchAuthor",
								placeholder: "author", value: @params.author
								
						text " "
						div class: "form-group", ->
							label class: "sr-only", ["for"]: "searchShowAmount", "Show (1 - 100)"
							input
								type: "number"
								class: "form-control"
								name: "showAmount"
								id: "searchShowAmount"
								min: "1", max: "100",
								placeholder: "show (1 - 100)"
								value: @params.showAmount

						button type: "submit", class: "btn btn-primary btn-sm pull-xs-right", ->
							i class: "fa fa-search"
							text " #{i18n 'search.title'}"

	-- Creating the "name" form group
	form_group_name: (advancedMode) =>
		div class: "form-group", ->
			label class: "sr-only", ["for"]: "searchGreedyName", i18n "search.sr_field_name"
			text " " if advancedMode
			input 
				type: "text"
				class: {"form-control", ["form-control-sm"]: not advancedMode}
				name: "name"
				id: "searchGreedyName"
				placeholder: i18n 'search.field_placeholder'
				required: true
				value: @params.name

	-- Creating the "type" form group
	form_group_type: (advancedMode) =>
		div class: "form-group", ->
			label class: "sr-only", ["for"]: "searchType", i18n "resources.type"
			element "select", name: "type", class: {"form-control", ["form-control-sm"]: not advancedMode, "c-select"}, ->
				option value: "any", selected: not @params.type, "any type"

				--  iterate through and create each option
				for opt in *{"script", "map", "gamemode", "misc"}
					option selected: @params.type == opt, opt