import Widget from require "lapis.html"
import write_csrf_input from require "utils"


class FollowForm extends Widget
	@include "widgets.utils"
	
	content: =>
		form class: "mta-inline-form", method: "POST", action: @url_for("user.follow", username: @user.username), ->
			input type: "hidden", name: "intent", value: followtext\lower!, ["aria-hidden"]: "true"

			@write_csrf_input!
			button type: "submit", class: "btn btn-default #{@isFollowing and '' or 'btn-success'}", ->
				i class: "fa fa-pencil"
				text @isFollowing and ' Unfollow' or ' Follow'