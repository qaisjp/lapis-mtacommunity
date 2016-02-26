import Widget from require "lapis.html"
import Users from require "models"

breadcrumb = class extends Widget
	content: =>
		li class: "active", "Site Settings"

main = class MTAAdminSettings extends Widget
	@include require "widgets.utils"

	category: "Settings"
	content: =>
		
		element "table", class: "table table-hover table-bordered table-sm table-href", ->
			thead ->
				label class: "pull-xs-right", ->
					input type: "checkbox", disabled: true
					text " check the box to update values"
				tr ->
					th "setting_id"
					th "setting_name"
					th "setting_value"
					th ""
			tbody ->

				-- example
				tr ->
					td ""
					td ""
					td ""
					td ->
						input type: "checkbox"

				
				-- for user in *paginated\get_page @page
				-- 	tr ["data-href"]: (@url_for "admin.manage_user", user_id: user.id), ->
				-- 		td scope: "row", user.id
				-- 		td user.username
				-- 		td user.created_at
				-- 		td ->
				-- 			a href: @url_for("user.profile", username: user.slug), class: "btn btn-sm btn-secondary", ->
				-- 				i class: "fa fa-user"
				-- 				text " profile"

				-- 			raw " " -- spacing..

				-- 			a href: @url_for("admin.manage_user", user_id: user.id), class: "btn btn-sm btn-secondary", ->
				-- 				i class: "fa fa-cogs"
				-- 				text " manage"

				-- 			raw " " -- spacing..

				-- 			form class: "mta-inline-form", method: "POST", action: @url_for("admin.become"), ->
				-- 				@write_csrf_input!
				-- 				input type: "hidden", name: "user_id", value: user.id, ["aria-hidden"]: "true"
				-- 				button type: "submit", class: "btn btn-sm btn-secondary", ->
				-- 					i class: "fa fa-eye"
				-- 					text " become"

{:main, :breadcrumb}