import Widget from require "lapis.html"

class MTAAdminHome extends Widget
	@include "widgets.utils"

	content: =>
		h2 "Statistics"
		p "Here are the statistics for the website"
		ul ->
			li "Total users: " .. (@user_count or "<error>")
			li "Total resources: " .. (@resource_count or "<error>")
			li "Total bans: " .. (@ban_count or "<error>")
			li ->
				text "Currently banned users: "
				text @banned_users_count or "<error>"
				text " "
				form class: "mta-inline-form", method: "POST", action: @url_for("admin.update_bans", nil, redirect_to: ngx.var.request_uri), ->
					@write_csrf_input!
					button type: "submit", class: "btn btn-default btn-xs", ->
						i class: "fa fa-refresh fa-spin"
						text " update"
				
			li "Gallery photos uploaded: " .. (@gallery_count or "<error>")
			li "Total users followed:  " .. (@follows_count or "<error>")
