import Widget from require "lapis.html"

class MTASettingsLayout extends Widget
	content: =>
		viewWidget = require "views." .. @route_name
		div class: "col-md-2", ->
			div class: "card", ->
				div class: "card-header", "Settings"
				div class: "card-block", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->
						for name in *{"Profile", "Account"}
							li role: "presentation", class: "nav-item", ->
								a {
									class: "nav-link" .. (if name == viewWidget.name then " active" else "")
									href: @url_for("settings." .. name\lower!)
								}, name

		div class: "col-md-10", -> widget viewWidget