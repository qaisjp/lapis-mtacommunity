import Widget from require "lapis.html"
import Bans, Users from require "models"
import to_json from require "lapis.util"

class MTAAdminBans extends Widget
	content: =>
		@content_for "breadcrumb", ->
			li -> a href: @url_for "admin.bans", "Bans"
			li class: "active", "Ban #" .. @ban.id
				
		banned_user = @ban\get_banned_user!
		banner = @ban\get_banner!
		h2 "Ban on " .. to_json banned_user