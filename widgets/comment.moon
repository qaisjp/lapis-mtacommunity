import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"

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
					span "[deleted]"
				span class: "text-muted", @comment.parent and " replied " or " commented "
				a class: "text-muted", href: "#"..anchor, ->
					text time_ago_in_words @comment.created_at

					if @comment.edited_at
						text " (modified "
						text time_ago_in_words @comment.edited_at
						text ")"

				if can_show_reply
					a style: "cursor:pointer;", class: "pull-xs-right", onclick:"$('#commentreply-#{@comment.id}').toggle()", "reply"
			div class: "card-block", ->
				text @comment.message

			if can_show_reply
				div class: "card-footer", id: "commentreply-#{@comment.id}", style: "display:none;", ->
					form action: @url_for("resources.comment", resource_slug: @resource.slug), method: "POST", ->
						@write_csrf_input @

						input type: "hidden", name: "comment_parent", value: @comment.id, ["aria-hidden"]: "true"
						label class: "sr-only", ["for"]: "comment_text", "Comment reply message:"
						textarea class: "form-control", rows: 1, placeholder: "place your comment here", required: true, id: "comment_text", name: "comment_text"
						button class: "btn btn-sm btn-secondary", type: "submit", " Comment"

			if @childComments
				for comment in *@childComments
					widget CommentWidget :comment