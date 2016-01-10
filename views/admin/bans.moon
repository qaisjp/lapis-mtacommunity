import Widget from require "lapis.html"
import Bans, Users from require "models"
import to_json from require "lapis.util"

breadcrumb = class extends Widget
	content: =>
		li class: "active", "Bans"

main = class MTAAdminBans extends Widget
	@include require "widgets.utils"

	category: "Bans"
	content: =>
		paginated = Bans\paginated "order by created_at desc",
			per_page: 2
			prepare_results: (bans) ->
				Users\include_in bans, "banned_user", as: "banned_user"--, fields: "username"
				Users\include_in bans, "banner", as: "banner"--, fields: "username"
				bans

		pages = paginated\num_pages!
		p "page #{@page} of #{pages}"
		element "table", class: "table table-hover table-bordered table-sm table-href", ->
			thead ->
				tr ->
					th "#"
					th "banned user"
					th "banner"
					th "reason"
					th "date of ban"
					th "expiry date"
					th ""
			tbody ->
				for ban in *paginated\get_page @page
					tr ["data-href"]: (@url_for "admin.view_ban", ban_id: ban.id), ->
						th scope: "row", ban.id
						td -> a href: (@url_for "user.profile", username: ban.banned_user.username), ban.banned_user.username
						td -> a href: (@url_for "user.profile", username: ban.banner.username), ban.banner.username
						td ban.reason
						td ban.created_at
						td ban.expires_at
						td -> span class: "label label-#{ban.active and 'warning' or 'default'}", ->
							text "#{ban.active and '' or 'in'}active"
					-- li to_json(ban)

		@write_pagination_nav "admin.bans", pages, @page

{:breadcrumb, :main}