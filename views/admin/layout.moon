import Widget from require "lapis.html"

class MTAAdminLayout extends Widget
	content: =>
		-- I absolutely hate this implementation
		-- I wanted to use the same widget, so I tried all these ways:
		-- * @content_for with a simple widget render at the bottom
		-- * @content_for, rendering the widget at the top, and printing out raw
		-- * render widget at the top, but get content using widget\content_for (returns empty string)
		-- * instead of content:=>, try breadcrumb:=> (content is hardcoded into render_text_string)
		-- * to get around hardcode, try to swap function variables (doesn't work)
		import main, breadcrumb from require "views." .. @route_name

		div class: "page-header", ->
			ol class: "breadcrumb", ->
				li -> a href: @url_for("admin.dashboard"), "Administration"
				widget breadcrumb
			
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
				widget main