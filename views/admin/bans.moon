import Widget from require "lapis.html"
import Bans, Users from require "models"
import to_json from require "lapis.util"

class MTAAdminBans extends Widget
	content: =>
		paginated = Bans\paginated "order by created_at desc",
			per_page: 2
			prepare_results: (bans) ->
				Users\include_in bans, "banned_user", as: "banned_user"--, fields: "username"
				Users\include_in bans, "banner", as: "banner"--, fields: "username"
				bans

		pages = paginated\num_pages!
		h2 "Bans - page #{@page} of #{pages}"
		element "table", class: "table table-hover table-bordered table-condensed table-href", ->
			thead ->
				tr ->
					th "#"
					th "banned user"
					th "banner"
					th "reason"
					th "date of ban"
					th "expiry date"
			tbody ->
				for ban in *paginated\get_page @page
					tr ["data-href"]: (@url_for "admin.view_ban", ban_id: ban.id), ->
						th scope: "row", ban.id
						td -> a href: (@url_for "user_profile", username: ban.banned_user.username), ban.banned_user.username
						td -> a href: (@url_for "user_profile", username: ban.banner.username), ban.banner.username
						td ban.reason
						td ban.created_at
						td ban.expires_at
					-- li to_json(ban)

		nav -> ul class: "pagination", ->
			li -> a href: "#", ["aria-label"]: "Previous", -> span ["aria-hidden"]: "true", -> raw "&laquo;"
			for page = 1, pages
				li -> a href: @url_for("admin.bans", nil, page: page), page
			li -> a href: "#", ["aria-label"]: "Next", -> span ["aria-hidden"]: "true", -> raw "&laquo;"
      			