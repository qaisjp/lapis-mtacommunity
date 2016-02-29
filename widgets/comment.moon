import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"

class CommentWidget extends Widget
	@include "widgets.utils"
	
	content: =>
		if not @comment then
			return p "Internal error: no comment passed to widget!"

		anchor = "comment-#{@comment.id}"
		div class: "card", id: anchor, ->
			div class: "card-header", ->
				if @comment.author
					a style: "color: inherit;", href: @url_for("user.profile", username: @comment.author.slug), -> strong @comment.author.username
				else
					span "[deleted]"
				span class: "text-muted", " commented "
				a class: "text-muted", href: "#"..anchor, ->
					text time_ago_in_words @comment.created_at

					if @comment.edited_at
						text " (modified "
						text time_ago_in_words @comment.edited_at
						text ")"
			div class: "card-block", ->
				text @comment.message