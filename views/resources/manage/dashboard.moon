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

		div class: "card", ->
			div class: "card-header", ->
				text "Your permissions"

			div class: "card-block", ->
				element "table", class: "table", ->
					thead ->
						th "right"
						th "value"
					tbody ->
						for right in *{"configure", "moderate", "manage_managers", "manage_packages", "upload_screenshots"}							
							tr ->
								td "can_#{right}"
								td tostring @rights["can_#{right}"]