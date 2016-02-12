import Widget from require "lapis.html"
import get_gravatar_url from require "utils"
import Users, UserFollowings from require "models"
import time_ago_in_words from require "lapis.util"
db = require "lapis.db"	

build_cards = {
	following: true
	followers: true
	follow: (users) => ->
		local closedColumn
		for i, user in ipairs users
			if (i-1)%2 == 0
				raw '<div class="col-md-4">'
				closedColumn = false

			div class: "card", ->
				div class: "card-header", ->
					a href: @url_for("user.profile", username: user.username), user.username
				img src: get_gravatar_url(user.email, 75), alt: "#{user.username}'s email"
				text "Following for #{time_ago_in_words user.followed_at, nil, ''}"

			if (i-1)%2 == 1
				raw '</div>'
				closedColumn = true

		unless closedColumn
			raw "</div>"

	resources: => "resource"
	comments: => "comment"
	screenshots: => "screen"
}

class MTAUserLayout extends Widget
	@include require "widgets.utils"
	content: =>
		div class: "page-header", ->
			div class: "media", ->
				div class: "media-left", -> img class: "media-object", src: get_gravatar_url @user.email, 150
				div class: "media-body", ->
					h1 class: "media-heading", "#{@user.username}"
					
					p ->
						i class: "fa fa-fw fa-clock-o"
						text "Member for #{time_ago_in_words @user.created_at, nil, ''}"

					if loc = @data.location
						p ->
							i class: "fa fa-fw fa-map-marker"
							text loc

					if url = @data.website
						p ->
							i class: "fa fa-fw fa-link"
							a href: url, url

					if gang = @data.gang
						p ->
							i class: "fa fa-fw fa-users"
							text "Gang: #{gang}"

					if birthday = @data.birthday
						p ->
							i class: "fa fa-fw fa-birthday-cake"
							text: "Birthday: #{birthday}"

				div class: "media-right", ->
					div class: "btn-group-vertical", role: "group", ["aria-label"]: "Profile Buttons", ->
						if @active_user
							admin_mode = @active_user\can_manage @user
							self_mode  = @active_user.id == @user.id

							if self_mode or admin_mode
								url = if admin_mode and not self_mode
										-- @url_for "admin.view_user", user: @user.id
										"soon"
									else
										@url_for "settings.profile"

								a href: url, class: "btn btn-secondary" , ->
									i class: "fa fa-pencil"
									text " Edit profile"

							if (@active_user.id ~= @user.id)
								-- We follow them
								-- should use widget, cloned in follow.moon
								widget require "widgets.user_follow_form"
		
		hr!

		div class: "container", ->
			div class: "row", ->
				tab = build_cards[@params.tab] and @params.tab or "resources"

				div class: "col-md-2 ", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->
						for name in *{"Resources", "Followers", "Following", "Screenshots", "Comments"}
							lowerName = string.lower name

							-- make the "resources" page not really need ?tab=resources
							href = (name == "Resources") and "?" or "?tab=#{lowerName}"

							li role: "presentation", class: "nav-item", -> a class: {"nav-link", active: tab == lowerName}, :href, ->
								text name .. " "
								span class: "label label-pill label-default", @[lowerName .. "_count"]
						
				div class: "col-md-10",
					if (tab == "followers") or (tab == "following")
						raw build_cards.follow @, @[tab]
					else
						raw build_cards[tab] @, @[tab]
						

		@content_for "post_body_script", ->
			script type: "text/javascript", -> raw "check_tablinks()"