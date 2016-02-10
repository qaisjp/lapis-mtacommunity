import Widget from require "lapis.html"
import write_csrf_input from require "utils"


class FollowForm extends Widget
	@include "widgets.utils"
	
	content: =>
		followtext = @isFollowing and 'Unfollow' or 'Follow'
		form class: "mta-inline-form", method: "POST", action: @url_for("user.follow", username: @user.slug), ->
			input type: "hidden", name: "intent", value: followtext\lower!, ["aria-hidden"]: "true"

			@write_csrf_input!
			button type: "submit", class: "btn btn-secondary #{@isFollowing and '' or 'btn-success'}", ->
				i class: "fa fa-bell"
				text " " .. followtext