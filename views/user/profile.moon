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
										-- @url_for "admin.view_user", user: @user.id
										"soon"
									else
										@url_for "settings.profile"

								a href: url, class: "btn btn-default" , ->
									i class: "fa fa-pencil"
									text " Edit profile"

							if (@active_user.id ~= @user.id)
								-- We follow them
								-- should use widget, cloned in follow.moon
								followtext = @isFollowing and 'Unfollow' or 'Follow'
								form class: "mta-inline-form", method: "POST", action: @url_for("user.follow", username: @user.slug), ->
									input type: "hidden", name: "intent", value: followtext\lower!, ["aria-hidden"]: "true"

									@write_csrf_input!
									button type: "submit", class: "btn btn-default #{@isFollowing and '' or 'btn-success'}", ->
										i class: "fa fa-bell"
										text " " .. followtext
	

		div class: "container", ->
			div class: "row", ->
				div class: "col-md-2 ", ->
					ul class: "nav nav-pills nav-stacked mta-resources-tabs", role: "tablist", ->
						li role: "presentation", class: "active", -> a href: "#resources", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "resources", ->
							text "Resources "
							span class: "badge", @resource_count
						li role: "presentation", -> a href: "#followers", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "followers", ->
							text "Followers "
							span class:"badge", @followers
						li role: "presentation", -> a href: "#following", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "following", ->
							text "Following "
							span class: "badge", @following
						li role: "presentation", -> a href: "#screenshots", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "screenshots", ->
							text "Screenshots "
							span class: "badge", @screenshot_count
						li role: "presentation", -> a href: "#comments", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "comments", ->
							text "Comments "
							span class: "badge", @comment_count
				div class: "col-md-10", ->
					div class: "tab-content", ->
						div role: "tabpanel", class: "tab-pane fade in active", id: "resources", "res"
						div role: "tabpanel", class: "tab-pane fade", id: "followers", "fol"
						div role: "tabpanel", class: "tab-pane fade", id: "following", "folin"
						div role: "tabpanel", class: "tab-pane fade", id: "screenshots", "scren"
						div role: "tabpanel", class: "tab-pane fade", id: "comments", "com"


		@content_for "post_body_script", ->
			script type: "text/javascript", -> raw "check_user_page_tab()"