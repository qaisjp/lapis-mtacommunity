import Widget from require "lapis.html"
import Users, Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"
i18n = require "i18n"

class MTAResourcePage extends Widget
	@include "widgets.utils"
	content: =>
		div class: "card-block", ->
			text i18n "resources.table.rating"
			text ": #{@resource.rating}"
			br!
			if #@authors == 1
				text i18n "resources.manage.author.title.one"
				text ": "
				author = @authors[1]
				a href: @url_for(author), author.username
			else
				text i18n "resources.manage.author.title.many"
				text ": "
				for i, author in ipairs @authors
					text ", " unless i == 1
					a href: @url_for(author), author.username
			br!
			text @resource.description

		div class: "card-block", ->
			div class: "container", ->
				div class: "row", ->
					ul class: "nav nav-tabs mta-tablinks", role: "tablist", ->
						li role: "presentation", class: "nav-item", -> a class: "nav-link active", href: "#comments", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "comments", ->
							text i18n "comment.title.many"
							raw " "
							span class: "label label-pill label-default", @commentsPaginator\total_items!
						li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#changelog", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "changelog", ->
							text i18n "resources.manage.packages.changelog"
							raw " "
							span class:"label label-pill label-default", @packagesPaginator\total_items!
						li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#screenshots", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "screenshots", ->
							text i18n "users.tab_screenshots"
							raw " "
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
		if @active_user
			form action: @url_for("resources.post_comment", resource_slug: @resource), method: "POST", ->
				@write_csrf_input @
				label class: "sr-only", ["for"]: "comment_text", i18n "comment.sr_parent_message"
				textarea class: "form-control", name: "comment_text", id: "comment_text", required: true, placeholder: i18n "comment.message_placeholder"

				button class: "btn btn-primary", type: "submit", i18n "comment.title.one"
		else
			p i18n "comment.login_to"

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
		element "table", class: "table table-hover table-href table-bordered mta-resources-table", ->
			thead -> tr ->
				th i18n "resources.table.version"
				th i18n "resources.table.publish_date"
				th i18n "resources.table.changes"
			tbody ->
				for package in *packages
					tr ["data-href"]: @url_for("resources.get", resource_slug: @resource, version: package.version), ->
						td package.version
						td time_ago_in_words package.created_at
						td package.description

	write_screenshots: (paginated) =>
		screenshots = paginated\get_page 1

		ScreenshotWidget = require "widgets.screenshot"

		div id: "screenshots-carousel", class: "carousel slide", ["data-ride"]: "carousel", ->
			ol class: "carousel-indicators", ->
				li ["data-target"]: "#screenshots-carousel", ["data-slide-to"]: "0", class: "active"
				for i = 1, #screenshots - 1
					li ["data-target"]: "#screenshots-carousel", ["data-slide-to"]: tostring i
			div class: "carousel-inner", role: "listbox", ->
				for i, screenshot in ipairs screenshots
					screenshot.resource = @resource
					div class: ("carousel-item screenshots-carousel-item " .. ((i==1) and "active" or "")), ->
						a href: @url_for(screenshot), -> img src: screenshot\get_direct_url(@), alt: screenshot.title
						div class: "carousel-caption", ->
							h3 screenshot.title
							p screenshot.description
		
			a class: "left carousel-control", href: "#screenshots-carousel", role: "button", ["data-slide"]: "prev", ->
				span class: "icon-prev", ["aria-hidden"]: "true"
				span class: "sr-only", i18n "previous"

			a class: "right carousel-control", href: "#screenshots-carousel", role: "button", ["data-slide"]: "next", ->
				span class: "icon-next", ["aria-hidden"]: "true"
				span class: "sr-only", i18n "next"