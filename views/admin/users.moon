import Widget from require "lapis.html"
Users = require "models.users"

class MTAAdminBans extends Widget
	content: =>
		h1 "Users"

		ul ->
			for user in *Users\select!
				li ->
					a {
						href: @url_for "user_profile", username: user.username
					}, user.username
					text " (#{user.id}) - "
					a {
						href: @url_for "admin.become", username: user.username
					}, "become"