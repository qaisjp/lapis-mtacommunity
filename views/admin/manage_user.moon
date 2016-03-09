import Widget from require "lapis.html"
date = require "date"

breadcrumb = class extends Widget
	content: =>
		li -> a href: @url_for("admin.users"), "Users"
		li class: "active", "Manage #" .. @user.id

main = class MTAAdminBan extends Widget
	@include require "widgets.utils"

	category: "Users"
	content: =>
		user = @user

		div class: "card", ->
			div class: "card-header", ->
				text "Manage user \""
				a href: @url_for("user.profile", username: user.slug), user.username
				text "\""

				div class: "pull-xs-right", ->
					a class: "btn btn-sm btn-secondary", href: @url_for("admin.new_ban", nil, user_id: user.id), ->
						i class: "fa fa-ban"
						text " raise the ban hammer"
						
					raw " "
					form class: "mta-inline-form", method: "POST", action: @url_for("admin.become"), ->
						@write_csrf_input!
						input type: "hidden", name: "user_id", value: user.id, ["aria-hidden"]: "true"
						button type: "submit", class: "btn btn-sm btn-secondary", ->
							i class: "fa fa-eye"
							text " become"

			div class: "card-block", ->
				div ->
					text "User joined: "
					text date(user.created_at)\fmt "${rfc1123}"
				div ->
					text "Ban state: "

					is_banned = user\is_banned!
					if is_banned
						span class: "label label-pill label-warning", "currently banned"
					else
						span class: "label label-pill label-info", "not currently banned"
						raw " "
						

{:breadcrumb, :main}