import Widget from require "lapis.html"
import Users, Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcePage extends Widget
	@include "widgets.utils"
	content: =>
		div class: "card-block", ->
			ul ->
				li ->
					text "Authors: "
					for i, author in ipairs @authors
						text ", " unless i == 1
						a href: @url_for(author), author.username

			text @resource.description

		div class: "card-block", ->
			div class: "container", ->
				div class: "row", ->
					ul class: "nav nav-tabs mta-tablinks", role: "tablist", ->
						li role: "presentation", class: "nav-item", -> a class: "nav-link active", href: "#comments", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "comments", ->
							text "Comments "
							span class: "label label-pill label-default", @commentsPaginator\total_items!
						li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#changelog", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "changelog", ->
							text "Changelog "
							span class:"label label-pill label-default", @packagesPaginator\total_items!
						li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#screenshots", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "screenshots", ->
							text "Screenshots "
							span class:"label label-pill label-default", @screenshotsPaginator\total_items!
				div class: "row", ->
					div class: "tab-content", ->
						div role: "tabpanel", class: "tab-pane fade in active", id: "comments", -> @write_comments @commentsPaginator
						div role: "tabpanel", class: "tab-pane fade", id: "changelog", -> @write_changelog @packagesPaginator
						div role: "tabpanel", class: "tab-pane fade", id: "screenshots", -> @write_screenshots @screenshotsPaginator

		@content_for "post_body_script", ->
			script type: "text/javascript", -> raw "check_tablinks()"

	write_comments: (paginated) =>
		comments = paginated\get_page 1
		text "#{paginated\num_pages!} pages. #{#comments} comments showing."

		if @active_user
			form action: @url_for("resources.post_comment", resource_slug: @resource), method: "POST", ->
				@write_csrf_input @
				label class: "sr-only", ["for"]: "comment_text", "Comment message:"
				textarea class: "form-control", name: "comment_text", id: "comment_text", required: true, placeholder: "markdown comment..."

				button class: "btn btn-primary", type: "submit", " Comment"
		else
			p "Log in to leave a comment"

		CommentWidget = require "widgets.comment"
		childComments = {}

		-- add all children to parent pool
		for comment in *comments
			if comment.parent
				childComments[comment.parent] = {} if not childComments[comment.parent]
				table.insert childComments[comment.parent], comment

		-- now try to render all parents
		for comment in *comments
			if not comment.parent
				widget CommentWidget :comment, childComments: childComments[comment.id]


	write_changelog: (paginated) =>
		packages = paginated\get_page 1
		text "#{paginated\num_pages!} pages. #{#packages} packages showing."

		element "table", class: "table table-hover table-href table-bordered mta-resources-table", ->
			thead -> tr ->
				th "Version"
				th "Date Published"
				th "Changes"
			tbody ->
				for package in *packages
					tr ["data-href"]: @url_for("resources.get", resource_slug: @resource, version: package.version), ->
						td package.version
						td time_ago_in_words package.created_at
						td package.description

	write_screenshots: (paginated) =>
		screenshots = paginated\get_page 1
		text "#{paginated\num_pages!} pages. #{#screenshots} screenshots showing."

		ScreenshotWidget = require "widgets.screenshot"

		ul class: "media-list", ->
			for screenshot in *screenshots
				widget ScreenshotWidget :screenshot, resource: @resource