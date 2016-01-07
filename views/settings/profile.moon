import Widget from require "lapis.html"

class MTAUserProfile extends Widget
	content: =>
		div class: "page-header noborder"
		div class: "col-md-2", ->
			div class: "card", ->
				div class: "card-header", "Settings"
				div class: "card-block", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->
						li class: "nav-item", role: "presentation", -> a class: "nav-link active", href: "#", ->
							text "Account"
						li class: "nav-item", role: "presentation", -> a class: "nav-link", href: "#", ->
							text "Profile "

		div class: "col-md-10", ->
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