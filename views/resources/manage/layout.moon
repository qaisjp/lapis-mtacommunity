import Widget from require "lapis.html"

class MTAResourceManageLayout extends Widget
	content: =>
		viewWidget = require "views." .. @route_name

		div class: "col-md-2", ->
			div class: "card", ->
				a class: "btn btn-secondary", href: @url_for(@resource), ->
					i class: "fa fa-arrow-left"
					text " Back"
			div class: "card", ->
				div class: "card-block", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->

						-- see applications.manage_resource to make these sections work properly for everyone
						for name in *{"Dashboard", "Details", "Authors", "Settings"}
							if @tabs[name\lower!]
								li role: "presentation", class: "nav-item", ->
									a {
										class: "nav-link" .. (if name == viewWidget.name then " active" else "")
										href: @url_for "resources.manage.#{name\lower!}", resource_slug: @resource.slug
									}, name

		div class: "col-md-10", -> widget viewWidget