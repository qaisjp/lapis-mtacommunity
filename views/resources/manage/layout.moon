import Widget from require "lapis.html"

class MTAResourceManageLayout extends Widget
	content: =>
		viewWidget = require "views.resources.manage." .. @params.tab
		div class: "col-md-2", ->
			div class: "card", ->
				div class: "card-header", "Manage"
				div class: "card-block", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->
						for name in *{"Dashboard", "Details", "Settings"}
							if @tabs[name\lower!]
								li role: "presentation", class: "nav-item", ->
									a {
										class: "nav-link" .. (if name == viewWidget.name then " active" else "")
										href: @url_for "resources.manage", tab: name\lower!, resource_slug: @resource.slug
									}, name

		div class: "col-md-10", -> widget viewWidget