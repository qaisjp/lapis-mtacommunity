import Widget from require "lapis.html"
import get_gravatar_url from require "utils"
import Users, UserFollowings from require "models"
i18n = require "i18n"
db = require "lapis.db"

class MTAUserFollow extends Widget
	@include require "widgets.utils"
	content: =>
		followtext = @isFollowing and 'Unfollow' or 'Follow'

		div class: "page-header", ->
			h1 i18n "users.confirm_#{followtext\lower!}", name: @user.username

		div class: "row", ->
			-- should use widget, cloned in profile.moon
			form class: "mta-inline-form", method: "POST", action: @url_for("user.follow", username: @user.username), ->
				input type: "hidden", name: "intent", value: followtext\lower!, ["aria-hidden"]: "true"

				@write_csrf_input!
				button type: "submit", class: "btn btn-secondary #{@isFollowing and '' or 'btn-success'}", ->
					i class: "fa fa-pencil"
					text " " .. followtext