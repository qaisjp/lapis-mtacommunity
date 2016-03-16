import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"
i18n = require "i18n"

class CommentWidget extends Widget
	@include "widgets.utils"
	
	content: =>
		if not @comment then
			return p "Internal error: no comment passed to widget!"

		anchor = "comment-#{@comment.id}"
		can_show_reply = @active_user and @resource and not @comment.parent

		div class: "card", id: anchor, ->
			div class: "card-header", ->
				if @comment.author
					a style: "color: inherit;", href: @url_for("user.profile", username: @comment.author.slug), -> strong @comment.author.username
				else
					span "[#{i18n 'comment.deleted'}]"
				span class: "text-muted", @comment.parent and " #{i18n 'comment.user_replied'} " or " #{i18n 'comment.user_commented'} "
				a class: "text-muted", href: "#"..anchor, ->
					text time_ago_in_words @comment.created_at

					if @comment.edited_at
						text " (#{i18n 'comment.user_modified'} "
						text time_ago_in_words @comment.edited_at
						text ")"

				div class: "pull-xs-right", ->
					if can_show_reply
						a class: "btn btn-secondary btn-sm", onclick:"$('#commentreply-#{@comment.id}').toggle()", i18n "comment.reply"
					raw " "

					if @active_user and ((@rights and @rights.can_moderate) or @active_user\can_open_admin_panel! or (@comment.author.id == @active_user.id))
						form method: "POST", action: @url_for("resources.delete_comment", resource_slug: @resource, comment: @comment.id), class: "mta-inline-form", ->
							@write_csrf_input!
							button type: "submit", class: "btn btn-secondary btn-sm", -> i class: "fa fa-remove"

			div class: "card-block", ->
				text @comment.message

			if can_show_reply
				div class: "card-footer", id: "commentreply-#{@comment.id}", style: "display:none;", ->
					form action: @url_for("resources.post_comment", resource_slug: @resource.slug), method: "POST", ->
						@write_csrf_input @

						input type: "hidden", name: "comment_parent", value: @comment.id, ["aria-hidden"]: "true"
						label class: "sr-only", ["for"]: "comment_text", "#{i18n 'comment.reply_message'}:"

						textarea class: "form-control", rows: 1, placeholder: i18n("comment.message_placeholder"), required: true, id: "comment_text", name: "comment_text"
						button class: "btn btn-sm btn-secondary", type: "submit", " #{i18n 'comment.title.one'}"

			if @childComments
				for comment in *@childComments
					widget CommentWidget :comment