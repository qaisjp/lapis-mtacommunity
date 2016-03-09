import Widget from require "lapis.html"
date = require "date"

breadcrumb = class extends Widget
	content: =>
		li -> a href: @url_for("admin.bans"), "Bans"
		li class: "active", "New ban"

main = class MTAAdminBanNew extends Widget
	@include require "widgets.utils"

	category: "Bans"
	content: =>
		unless @params.user_id
			p "Enter the username/slug/email of the user you want to ban:"

			form class: "mta-inline-form", method: "GET", action: @url_for("admin.new_ban"), ->
				input name: "search_user"
				button type: "submit", class: "btn btn-sm btn-secondary", ->	
					text " find by name..."

			p "Or enter the ID of the user you want to ban:"
			form class: "mta-inline-form", method: "GET", action: @url_for("admin.new_ban"), ->
				input name: "user_id"
				button type: "submit", class: "btn btn-sm btn-secondary", ->	
					text "  find by id..."
			return

		p "bannning #{@params.user_id}"
		
{:breadcrumb, :main}