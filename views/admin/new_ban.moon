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
		@output_errors!

		unless @user
			div ->
				label for: "search_user", "Enter the username/slug/email of the user you want to ban:"
				form class: "form-inline", method: "GET", action: @url_for("admin.new_ban"), ->
					div class: "form-group", ->
						label class: "sr-only", for: "search_user", "Username: "
						input type: "text", class: "form-control", id: "search_user", name: "search_user", placeholder: "username"
					
					raw " "
					button type: "submit", class: "btn btn-sm btn-secondary", "find by name..."
			br!
			div ->
				label for: "user_id", "Or enter the ID of the user you want to ban:"
				form class: "form-inline", method: "GET", action: @url_for("admin.new_ban"), ->
					div class: "form-group", ->
						label class: "sr-only", for: "user_id", "User ID: "
						input type: "number", class: "form-control", id: "user_id", name: "user_id", placeholder: "id", min: 0, step: 1

					raw " "
					button type: "submit", class: "btn btn-sm btn-secondary", ->	
						text "  find by id..."
			return

		p "You will be banning \"#{@user.username}\" (id: #{@user.id}, slug: #{@user.slug})"
		
{:breadcrumb, :main}