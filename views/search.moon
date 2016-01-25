import Widget from require "lapis.html"

class Search extends Widget
	content: =>
		widget require "widgets.search"
		
		div class: "card", ->
			div class: "card-header", ->
				text "Search Results"
				a href: @url_for("search", nil, @params), class: "btn btn-sm btn-primary pull-xs-right", -> i class: "fa fa-link"
