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
					for name in *{"Dashboard", "Users", "Bans", "Console"}
						li role: "presentation", class: "nav-item", ->
							a {
								class: {"nav-link", active: name == main.category}
								href: @url_for("admin." .. name\lower!)
							}, name

			div class: "col-md-10", ->
				widget main