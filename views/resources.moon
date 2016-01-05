import Widget from require "lapis.html"

class MTAUserProfile extends Widget
	content: =>
		div class: "page-header", ->
			h1 "Resources"

		div class: "container", ->
			div class: "row", ->
				div class: "card mta-resources-search", ->
					div class: "card-header", "Search"
					div class: "card-block", -> "Search Contents"

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", "Most Downloaded"
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

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", "Best Resources"
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

			div class: "row", ->
				div class: "card", ->
					div class: "card-header", "Recently Uploaded"
					div class: "card-block", ->
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