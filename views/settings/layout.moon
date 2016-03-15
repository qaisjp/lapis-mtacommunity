import Widget from require "lapis.html"
i18n = require "i18n"

class MTASettingsLayout extends Widget
	content: =>
		viewWidget = require "views." .. @route_name
		div class: "col-md-2", ->
			div class: "card", ->
				div class: "card-header", "Settings"
				div class: "card-block", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->
						for name in *{"profile", "account"}
							li role: "presentation", class: "nav-item", ->
								a {
									class: "nav-link" .. (if name == viewWidget.category then " active" else "")
									href: @url_for("settings." .. name)
								}, i18n "settings.#{name}"

		div class: "col-md-10", -> widget viewWidget