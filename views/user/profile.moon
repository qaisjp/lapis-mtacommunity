import Widget from require "lapis.html"
import get_gravatar_url from require "utils"
import Users, UserFollowings from require "models"
import time_ago_in_words from require "lapis.util"

ScreenshotWidget = require "widgets.screenshot"

db   = require "lapis.db"	
i18n = require "i18n"

build_cards = {
	following: 1, followers: 1, comments: true, screenshots: true
	follow: (user) => ->
		div class: "card-header", ->
			img src: get_gravatar_url(user.email, 75), alt: i18n("users.gravatar_alt", name: user.username)
			raw " "
			a href: @url_for("user.profile", username: user.username), user.username
		div class: "card-block", ->
			text " "
			text i18n "users.card_follow_time", duration: time_ago_in_words user.followed_at, nil, ''

	resources: (resource) => ->
		div class: "card-header", ->
			a href: @url_for("resources.view", resource_slug: resource.slug), resource.name
		div class: "card-block", ->
			text " #{i18n 'resources.table.downloads'}: #{resource.downloads}"
			br!
			text " #{i18n 'resources.table.rating'}: #{resource.rating}"
}

class MTAUserLayout extends Widget
	@include require "widgets.utils"
	content: =>
		-- make it go into protected mode if
		-- the setting is not explicitly public
		-- this way if somehow something breaks,
		-- it will default to protecting everyone
		protectedMode = @data.privacy_mode != 1

		if protectedMode and @active_user
			protectedMode = not (  (@user\is_following @active_user) or (@active_user.id == @user.id)  )

		div class: "page-header", ->
			div class: "media", ->
				div class: "media-left", -> img class: "media-object", src: get_gravatar_url @user.email, 150
				div class: "media-body", ->
					h1 class: "media-heading", "#{@user.username}"
					
					
					i class: "fa fa-fw fa-clock-o"
					raw " "
					text i18n "users.member_for_duration", duration: time_ago_in_words @user.created_at, nil, ''

					if protectedMode
						p i18n "users.private_profile"
						return 

					if loc = @data.location
						br!
						i class: "fa fa-fw fa-map-marker"
						raw " "
						text loc

					if url = @data.website
						br!
						i class: "fa fa-fw fa-link"
						raw " "
						a href: @build_url(url), i18n "users.website"

					if gang = @data.gang
						br!
						i class: "fa fa-fw fa-users"
						raw " "
						text "#{i18n 'users.gang'}: #{gang}"

					if birthday = @data.birthday
						br!
						i class: "fa fa-fw fa-birthday-cake"
						raw " "
						text "#{i18n 'users.cakeday'}: #{birthday}"

				div class: "media-right", ->
					div class: "btn-group-vertical", role: "group", ["aria-label"]: i18n("users.profile_buttons"), ->
						if @active_user							
							if @active_user\can_manage @user
								a href: @url_for("admin.manage_user", user_id: @user.id), class: "btn btn-secondary", ->
									i class: "fa fa-cogs"
									raw  " "
									text i18n "users.manage_user"

							if (@active_user.id == @user.id)
								a href: @url_for("settings.profile"), class: "btn btn-secondary" , ->
									i class: "fa fa-pencil"
									raw " "
									text i18n "users.edit_profile"
							else
								-- We follow them
								widget require "widgets.user_follow_form"
		
		return if protectedMode
		hr!

		div class: "container", ->
			div class: "row", ->
				tab = build_cards[@params.tab] and @params.tab or "resources"

				div class: "col-md-2 ", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->
						for name in *{"resources", "followers", "following", "screenshots", "comments"}
							-- make the "resources" page not really need ?tab=resources
							href = (name == "resources") and @user.slug or "?tab=#{name}"

							li role: "presentation", class: "nav-item", -> a class: {"nav-link", active: tab == name}, :href, ->
								text i18n("users.tab_#{name}") .. " "
								span class: "label label-pill label-default", @[name .. "_count"]
						
				div class: "col-md-10", ->
					if build_cards[tab] and (build_cards[tab] != true)
						local closedColumn
						for i, cardItem in ipairs @[tab] or {}
							if (i-1)%2 == 0
								raw '<div class="col-md-4">'
								closedColumn = false
							
							div class: "card", ->
								if (tab == "followers") or (tab == "following")
									raw build_cards.follow @, cardItem
								else
									raw build_cards[tab] @, cardItem

							if (i-1)%2 == 1
								raw '</div>'
								closedColumn = true

						unless closedColumn
							raw "</div>"
					elseif tab == "comments"
						CommentWidget = require "widgets.comment"
						for _, comment in ipairs @comments
							div class: "row", ->
								widget CommentWidget :comment
					elseif tab == "screenshots"
						ScreenshotWidget = require "widgets.screenshot"
						for _, screenshot in ipairs @screenshots
							widget ScreenshotWidget :screenshot
							br!
					

		@content_for "post_body_script", ->
			script type: "text/javascript", -> raw "check_tablinks()"