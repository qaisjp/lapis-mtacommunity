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
							li role: "presentation", class: "nav-item", ->
								a {
									class: "nav-link" .. (if name == viewWidget.name then " active" else "")
									href: @url_for "resources.manage", tab: name\lower!, resource_slug: @resource.slug
								}, name

		div class: "col-md-10", -> widget viewWidget


	-- content: =>
	-- 	div class: "card", ->
	-- 		div class: "card-header", ->
	-- 			text "Manage #{@resource.longname} (#{@resource.name})"

	-- 		div class: "card-block", ->
	-- 			p "buttons"

	-- 		div class: "card-block", ->
	-- 			p "can_configure: #{@rights.can_configure}"
	-- 			p "can_moderate: #{@rights.can_moderate}"
	-- 			p "can_manage: #{@rights.can_manage}"
	-- 			p "can_upload_packages: #{@rights.can_upload_packages}"
	-- 			p "can_upload_screenshots: #{@rights.can_upload_screenshots}"