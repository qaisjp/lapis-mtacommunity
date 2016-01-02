import Widget from require "lapis.html"

class MTAUserProfile extends Widget
	content: =>
		div class: "page-header", ->
			h1 "Your Profile"

		div class: "container", ->
			div class: "row", ->
				div class: "panel panel-default mta-resources-search", ->
					div class: "panel-heading", "Search"
					div class: "panel-body", -> "Search Contents"

			div class: "row", ->
				div class: "panel panel-default", ->
					div class: "panel-heading", "Most Downloaded"
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

			div class: "row", ->
				div class: "panel panel-default", ->
					div class: "panel-heading", "Best Resources"
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

			div class: "row", ->
				div class: "panel panel-default", ->
					div class: "panel-heading", "Recently Uploaded"
					div class: "panel-body", ->
						element "table", class: "table table-bordered mta-resources-table", ->
							thead -> tr ->
								th "Name"
								th "Version"
								th "Date Updated"
								th "T"
							tbody ->
								tr ->
									td "longname (shortname)"
									td "version"
									td "timestamp"
									td "s"