import Widget from require "lapis.html"
import Bans, Users from require "models"
import to_json from require "lapis.util"

breadcrumb = class extends Widget
	content: =>
		li -> a href: @url_for("admin.bans"), "Bans"
		li class: "active", "Ban #" .. @ban.id

main = class MTAAdminBan extends Widget
	content: =>
		banned_user = @ban\get_banned_user!
		banner = @ban\get_banner!
		h2 "Ban on " .. to_json banned_user

{:breadcrumb, :main}