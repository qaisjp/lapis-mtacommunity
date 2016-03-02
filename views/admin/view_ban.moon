import Widget from require "lapis.html"
import Bans, Users from require "models"
import to_json from require "lapis.util"

breadcrumb = class extends Widget
	content: =>
		li -> a href: @url_for("admin.bans"), "Bans"
		li class: "active", "Ban #" .. @ban.id

main = class MTAAdminBan extends Widget
	@include require "widgets.utils"

	category: "Bans"
	content: =>
		p ->
			text "User "
			a href: @url_for("user.profile", username: @banned_user.slug), @banned_user.username
			text " was banned by "
			a href: @url_for("user.profile", username: @banner.slug), @banner.username
			p "This user was banned for this reason: #{@ban.reason}"
			p "The ban was created at: #{@ban.created_at}" 
			text "The ban is currently "
				
			if @ban.active
				form class: "mta-inline-form", method: "POST", action: @url_for("admin.update_bans", {id: @ban.id}, redirect_to: ngx.var.request_uri), ->
					span class: "label label-warning", "active"
					text" "
					@write_csrf_input!
					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-refresh fa-spin"
						text " update"
			else
				span class: "label label-default", "inactive"

{:breadcrumb, :main}