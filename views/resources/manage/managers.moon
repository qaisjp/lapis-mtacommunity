import Widget from require "lapis.html"

class MTAResourceManageManagers extends Widget
	@include "widgets.utils"

	name: "Managers"
	content: =>
		div class: "card", ->
			div class: "card-header", "List of managers"
			div class: "card-block", ->
				element "table", class: "table", ->
					thead ->
						th "username"
						th "tools"
					tbody ->
						for manager in *@resource\get_authors nil, false
							tr ->
								td manager.username
						-- for right in *{"configure", "moderate", "manage_managers", "manage_packages", "upload_screenshots"}							
						-- 	tr ->
						-- 		td "can_#{right}"
						-- 		td tostring rights["can_#{right}"]

		div class: "card", ->
			div class: "card-header", ->
				text "Their permissions"

			div class: "card-block", ->
				-- for now just use our rights
				rights = @rights
				element "table", class: "table", ->
					thead ->
						th "right"
						th "value"
					tbody ->
						for right in *{"configure", "moderate", "manage_managers", "manage_packages", "upload_screenshots"}							
							tr ->
								td "can_#{right}"
								td tostring rights["can_#{right}"]