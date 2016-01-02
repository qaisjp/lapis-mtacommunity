import Widget from require "lapis.html"
import get_gravatar_url from require "utils"
import Users, UserFollowings from require "models"
db = require "lapis.db"

class MTAUserLayout extends Widget
	@include require "widgets.utils"
	content: =>
		div class: "page-header", ->
			div class: "media", ->
				div class: "media-left", -> img class: "media-object", src: get_gravatar_url @user.email, 150
				div class: "media-body", ->
					h1 class: "media-heading", "#{@user.username}"
					if date = @registration_date
						p ->
							i class: "fa fa-fw fa-clock-o"
							text "Registered #{@registration_date}"

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
							admin_mode = @active_user\can_manage @user
							self_mode  = @active_user.id == @user.id

							if self_mode or admin_mode
								url = if admin_mode and not self_mode
										@url_for "admin.view_user", user: @user.id
									else
										@url_for "settings.profile"

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
	

		div class: "container", ->
			div class: "row", ->
				div class: "col-md-10", -> --widget require "views." .. @route_name
				div class: "col-md-2 ", ->
					ul class: "nav nav-pills nav-stacked", role: "tablist", ->
						li role: "presentation", -> a href: "#", ->
							text "Resources "
							span class: "badge", @resource_count
						li role: "presentation", -> a href: "#", ->
							text "Followers "
							span class:"badge", @followers
						li role: "presentation", -> a href: "#", ->
							text "Following "
							span class: "badge", @following
						li role: "presentation", -> a href: "#", ->
							text "Screenshots "
							span class: "badge", @screenshot_count
						li role: "presentation", -> a href: "#", ->
							text "Comments "
							span class: "badge", @comment_count
