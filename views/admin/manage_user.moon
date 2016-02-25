import Widget from require "lapis.html"
import Bans, Users from require "models"
import to_json from require "lapis.util"

breadcrumb = class extends Widget
	content: =>
		li -> a href: @url_for("admin.users"), "Users"
		li class: "active", "Manage #" .. @user.id

main = class MTAAdminBan extends Widget
	@include require "widgets.utils"

	category: "Users"
	content: =>
		p ->
			text "User "
			a href: @url_for("user.profile", username: @user.slug), @user.username

{:breadcrumb, :main}