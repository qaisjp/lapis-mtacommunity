import Widget from require "lapis.html"

class MTAUserProfile extends Widget
	content: =>
		div class: "page-header", ->
			h1 "Resources"

		div class: "container", ->
			div class: "row", ->
				div class: "card mta-resources-search", ->
					div class: "card-header", ->
						a class: "btn btn-secondary btn-sm", role: "button", ["data-toggle"]: "collapse", href: "#advancedSearch", ["aria-expanded"]:"false", ["aria-controls"]: "advancedSearch", ->
							i class: "fa fa-cogs"
						text " Search"
						text " "
						form class: "mta-inline-form form-inline", ->
							div class: "form-group", ->
								label class: "sr-only", ["for"]: "searchGreedyName", "Name"
								text " "
								input type: "text", class: "form-control", id: "searchGreedyName", placeholder: "short or long name"
							text " "
							div class: "form-group", ->
								element "select", class: "c-select", ->
									option selected: true, "any type"
									option "script"
									option "map"
									option "gamemode"
									option "misc"
							button type: "submit", class: "btn btn-primary btn-sm pull-xs-right", -> i class: "fa fa-search"
					div class: "card-block collapse", id: "advancedSearch", -> "Search Contents"

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