import Widget from require "lapis.html"

class MTAAdminLayout extends Widget
	content: =>
		div class: "page-header", ->
			ol class: "breadcrumb", ->
				li -> a href: @url_for("admin.dashboard"), "Administration"
				@content_for "breadcrumb"
			
		div class:"row", ->
			div class: "col-md-2", ->
				ul class: "nav nav-pills nav-stacked", ->
					for name in *{"Dashboard", "Users", "Bans"}
						route_name = "admin." .. name\lower!
						li {
							role: "presentation",
							class: if route_name == @route_name then "active" else ""
						}, -> a href: @url_for(route_name), name

			div class: "col-md-10", ->
				-- div class: "panel panel-default", ->
				-- 	div class: "panel-body", ->
				widget require "views." .. @route_name