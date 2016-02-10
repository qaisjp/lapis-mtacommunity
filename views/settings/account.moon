import Widget from require "lapis.html"

class MTASettingsAccount extends Widget
	name: "Account"
	content: =>
		div class: "card", ->
			div class: "card-header", "Change password"
			div class: "card-block", ->
				element "table", class: "table table-bordered mta-resources-table", ->
					thead -> tr ->
						th "Name"
						th "Description"
						th "Downloads"
						th "T"
					tbody ->
						tr ->
							td "longname (shortname)"
							td "description"
							td "downloads"
							td "s"

		div class: "card", ->
			div class: "card-header bg-danger", "Delete account"
			div class: "card-block", ->
				p "Deleting your account removes all resources, names from your comments, and screenshots. The username also becomes available for other people to register."
				
