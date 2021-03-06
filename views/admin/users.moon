import Widget from require "lapis.html"
import Users from require "models"

breadcrumb = class extends Widget
	content: =>
		li class: "active", "Users"

main = class MTAAdminUsers extends Widget
	@include require "widgets.utils"

	category: "Users"
	content: =>
		paginated = Users\paginated "order by created_at desc",
			per_page: 5

		element "table", class: "table table-hover table-bordered table-sm table-href", ->
			thead ->
				tr ->
					th "#"
					th "Username"
					th "Creation Date"
					th "Tools"
			tbody ->
				for user in *paginated\get_page @page
					tr ["data-href"]: (@url_for "admin.manage_user", user_id: user.id), ->
						td scope: "row", user.id
						td user.username
						td user.created_at
						td ->
							a href: @url_for("user.profile", username: user.slug), class: "btn btn-sm btn-secondary", ->
								i class: "fa fa-user"
								text " profile"

							raw " " -- spacing..

							a href: @url_for("admin.manage_user", user_id: user.id), class: "btn btn-sm btn-secondary", ->
								i class: "fa fa-cogs"
								text " manage"

							raw " " -- spacing..

							form class: "mta-inline-form", method: "POST", action: @url_for("admin.become"), ->
								@write_csrf_input!
								input type: "hidden", name: "user_id", value: user.id, ["aria-hidden"]: "true"
								button type: "submit", class: "btn btn-sm btn-secondary", ->
									i class: "fa fa-eye"
									text " become"

		@write_pagination_nav "admin.users", paginated\num_pages!, @page

{:main, :breadcrumb}