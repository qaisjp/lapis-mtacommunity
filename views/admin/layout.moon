import Widget from require "lapis.html"

class MTAAdminLayout extends Widget
	content: =>
		div class:"row", -> div class: "col-md-4 col-md-offset-4", ->
			h1 "Administration"

		div class:"row", ->
			ul class: "nav nav-tabs", ->
				for name in *{"Dashboard", "Users", "Bans"}
					route_name = "admin." .. name\lower!
					li {
						role: "presentation",
						class: if route_name == @route_name then "active" else ""
					}, -> a href: @url_for(route_name), name

		div class:"row", -> div class: "col-md-12", ->
			widget require "views." .. @route_name