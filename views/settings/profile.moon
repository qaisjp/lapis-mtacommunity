import Widget from require "lapis.html"

class MTAUserProfile extends Widget
	content: =>
		div class: "page-header noborder"
		div class: "col-md-2", ->
			div class: "panel panel-default", ->
				div class: "panel-heading", "Settings"
				div class: "panel-body", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->
						li role: "presentation", -> a href: "#", ->
							text "Account"
						li role: "presentation", -> a href: "#", ->
							text "Profile "

		div class: "col-md-10", -> --widget require "views." .. @route_name
			div class: "panel panel-default", ->
				div class: "panel-heading", "Change password"
				div class: "panel-body", ->
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

			div class: "panel panel-default panel-danger", ->
				div class: "panel-heading", "Delete account"
				div class: "panel-body", ->
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