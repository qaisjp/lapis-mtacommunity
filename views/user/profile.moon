import Widget from require "lapis.html"
import get_gravatar_url from require "utils"
import Users, UserFollowings from require "models"
import time_ago_in_words from require "lapis.util"
db = require "lapis.db"

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
								followtext = @isFollowing and 'Unfollow' or 'Follow'
								form class: "mta-inline-form", method: "POST", action: @url_for("user.follow", username: @user.slug), ->
									input type: "hidden", name: "intent", value: followtext\lower!, ["aria-hidden"]: "true"

									@write_csrf_input!
									button type: "submit", class: "btn btn-secondary #{@isFollowing and '' or 'btn-success'}", ->
										i class: "fa fa-bell"
										text " " .. followtext
	
		hr!
		div class: "container", ->
			div class: "row", ->
				div class: "col-md-2 ", ->
					ul class: "nav nav-pills nav-stacked mta-tablinks", role: "tablist", ->
						li role: "presentation", class: "nav-item", -> a class: "nav-link active", href: "#resources", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "resources", ->
							text "Resources "
							span class: "label label-pill label-default", @resource_count
						li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#followers", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "followers", ->
							text "Followers "
							span class:"label label-pill label-default", #@followers
						li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#following", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "following", ->
							text "Following "
							span class: "label label-pill label-default", @following
						li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#screenshots", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "screenshots", ->
							text "Screenshots "
							span class: "label label-pill label-default", @screenshot_count
						li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#comments", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "comments", ->
							text "Comments "
							span class: "label label-pill label-default", @comment_count
				div class: "col-md-10", ->
					div class: "tab-content", ->
						div role: "tabpanel", class: "tab-pane fade in active", id: "resources", "res"
						div role: "tabpanel", class: "tab-pane fade", id: "followers", ->
							local closedColumn
							for i, follower in ipairs @followers
								if (i-1)%2 == 0
									raw '<div class="col-md-4">'
									closedColumn = false

								div class: "card", ->
									div class: "card-header", ->
										a href: @url_for("user.profile", username: follower.username), follower.username
									img src: get_gravatar_url(follower.email, 75), alt: "#{follower.username}'s email"
									text "Following for #{time_ago_in_words follower.followed_at, nil, ''}"
								
								if (i-1)%2 == 1
									raw '</div>'
									closedColumn = true

							unless closedColumn
								raw "</div>"

						div role: "tabpanel", class: "tab-pane fade", id: "following", "folin"
						div role: "tabpanel", class: "tab-pane fade", id: "screenshots", "scren"
						div role: "tabpanel", class: "tab-pane fade", id: "comments", "com"


		@content_for "post_body_script", ->
			script type: "text/javascript", -> raw "check_tablinks()"