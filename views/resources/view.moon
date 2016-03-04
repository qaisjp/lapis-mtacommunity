import Widget from require "lapis.html"
import Users, Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcePage extends Widget
	@include "widgets.utils"
	content: =>
		div class: "row", ->
			div class: "card", ->
				div class: "card-header", ->
					h2 ->
						text "#{@resource.longname} (#{@resource.name}) "
						span class: "label label-primary", Resources.types[@resource.type]

						span class: "pull-xs-right", ->
							if @active_user_is_author
								a class: "btn btn-secondary", href: @url_for("resources.manage", resource_slug: @params.resource_slug), ->
									i class: "fa fa-cogs"
									text " Manage"
								raw " "

							a class: "btn btn-primary", href: @url_for("resources.get", resource_slug: @params.resource_slug), ->
								i class: "fa fa-download"
								text " Download"

				div class: "card-block", ->
					ul ->
						li ->
							text "Authors: "
							for i, author in ipairs @authors
								text ", " unless i == 1
								a href: @url_for("user.profile", username: author.slug), author.username

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
						div class: "row", ->
							div class: "tab-content", ->
								div role: "tabpanel", class: "tab-pane fade in active", id: "comments", -> @write_comments @commentsPaginator
								div role: "tabpanel", class: "tab-pane fade", id: "changelog", -> @write_changelog @packagesPaginator

		@content_for "post_body_script", ->
			script type: "text/javascript", -> raw "check_tablinks()"

	write_comments: (paginated) =>
		comments = paginated\get_page 1
		ul ->
			li "#{paginated\num_pages!} pages. #{#comments} comments showing."

		if @active_user
			form action: @url_for("resources.comment", resource_slug: @resource.slug), method: "POST", ->
				@write_csrf_input @
				label class: "sr-only", ["for"]: "commentText", "Comment message:"
				textarea class: "form-control", name: "message", id: "commentText", required: true, placeholder: "markdown comment..."

				button class: "btn btn-primary", type: "submit", " Comment"
		else
			p "Log in to leave a comment"

		CommentWidget = require "widgets.comment"
		for comment in *comments
			widget CommentWidget :comment

	write_changelog: (paginated) =>
		packages = paginated\get_page 1
		ul ->
			li "#{paginated\num_pages!} packages. #{#packages} packages showing."

		element "table", class: "table table-hover table-href table-bordered mta-resources-table", ->
			thead -> tr ->
				th "Version"
				th "Date Published"
				th "Changes"
			tbody ->
				for package in *packages
					tr ["data-href"]: @url_for("resources.get", resource_slug: @resource.slug, version: package.version), ->
						td package.version
						td time_ago_in_words package.created_at
						td package.description