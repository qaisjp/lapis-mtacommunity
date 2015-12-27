import Widget from require "lapis.html"
import get_gravatar_url from require "utils"
import Users, UserFollowings from require "models"
db = require "lapis.db"

class MTAUserProfile extends Widget
	@include require "widgets.utils"
	content: =>
		div class: "page-header", ->
			div class: "media", ->
				div class: "media-left", -> img class: "media-object", src: get_gravatar_url @user.email, 150
				div class: "media-body", ->
					h1 class: "media-heading", "#{@user.username}"
					p ->
						i class: "fa fa-fw fa-clock-o"
						text "Joined on #{@user.created_at}"

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
					div class: "btn-group btn-group-sm", role: "group", ["aria-label"]: "Profile Buttons", ->
						if @active_user
							admin_mode = @active_user.level >= @user.level
							self_mode  = @active_user.id == @user.id
							if self_mode or admin_mode
								url = if admin_mode and not self_mode
										"adm"
										-- @url_for "admin.view_user", @user.id
									else
										"prof"
										-- @url_for "settings.profile"

								a href: url, class: "btn btn-default" , ->
									i class: "fa fa-pencil"
									text " Edit profile"

							if (@active_user.id ~= @user.id)
								-- We follow them
								-- should use widget, cloned in follow.moon
								followtext = @isFollowing and 'Unfollow' or 'Follow'
								form class: "mta-inline-form", method: "POST", action: @url_for("user.follow", username: @user.username), ->
									input type: "hidden", name: "intent", value: followtext\lower!, ["aria-hidden"]: "true"

									@write_csrf_input!
									button type: "submit", class: "btn btn-default #{@isFollowing and '' or 'btn-success'}", ->
										i class: "fa fa-bell"
										text " " .. followtext

							h4 "#{@followers} followers"
							h4 "#{@following} following"