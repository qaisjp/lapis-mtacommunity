import Widget from require "lapis.html"
import Bans, Users from require "models"
import to_json from require "lapis.util"

class MTAAdminBans extends Widget
	content: =>
		banned_user = @ban\get_banned_user!
		banner = @ban\get_banner!
		h2 "Ban on " .. to_json banned_user