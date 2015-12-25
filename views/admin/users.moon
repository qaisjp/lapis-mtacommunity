import Widget from require "lapis.html"
import Users from require "models"

class MTAAdminBans extends Widget
	@include require "widgets.utils"
	content: =>
		@content_for "breadcrumb", ->
			li class: "active", "Users"
				

		paginated = Users\paginated "order by created_at desc",
			per_page: 2
		
		pages = paginated\num_pages!
		p "page #{@page} of #{pages}"

		element "table", class: "table table-hover table-bordered table-condensed table-href", ->
			thead ->
				tr ->
					th "#"
					th "username"
					th "created_at"
					th ""
			tbody ->
				for user in *paginated\get_page @page
					tr ["date-href"]: (@url_for "user_profile", username: user.username), ->
						td scope: "row", user.id
						td user.username
						td user.created_at
						td -> form class: "mta-inline-form", method: "POST", action: @url_for("admin.become"), ->
							@write_csrf_input!
							button type: "submit", class: "btn btn-default btn-xs", ->
								i class: "fa fa-eye"
								text " become"

		@write_pagination_nav "admin.users", pages, @page