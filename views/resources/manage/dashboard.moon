import Widget from require "lapis.html"

class MTAResourceManageDashboard extends Widget
	@include "widgets.utils"

	name: "Dashboard"
	content: =>
		div class: "card", ->
			div class: "card-header", "Statistics"
			div class: "card-block", ->

		div class: "card", ->
			div class: "card-header", "Included by"
			div class: "card-block", ->