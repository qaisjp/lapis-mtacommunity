import Widget from require "lapis.html"
import write_csrf_input from require "utils"
i18n = require "i18n"

class FollowForm extends Widget
	@include "widgets.utils"
	
	content: =>
		followtext = @isFollowing and i18n('users.action_unfollow') or i18n('users.action_follow')
		form class: "mta-inline-form", method: "POST", action: @url_for("user.follow", (username: @user.slug), (tab: @params.tab)), ->
			input type: "hidden", name: "intent", value: followtext\lower!, ["aria-hidden"]: "true"

			@write_csrf_input!
			button type: "submit", class: "btn btn-secondary #{@isFollowing and '' or 'btn-success'}", ->
				i class: "fa fa-bell"
				text " " .. followtext