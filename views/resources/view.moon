import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import time_ago, time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcePage extends Widget
	content: =>
		div class: "row", ->
			div class: "card", ->
				div class: "card-header", ->
					h2 ->
						text "#{@resource.longname} (#{@resource.name}) "
						span class: "label label-primary", Resources.types[@resource.type]
						if @active_user_is_author
							a class: "btn btn-secondary pull-xs-right", href: @url_for("resources.edit", resource_name: @params.resource_name), ->
								i class: "fa fa-cogs"
								text " Manage"
				div class: "card-block", ->
					ul ->
						li ->
							text "Authors: "
							for i, author in ipairs @authors
								text ", " unless i == 1
								text author.username

				div class: "card-block", ->
					div class: "container", ->
						div class: "row", ->
							ul class: "nav nav-tabs mta-tablinks", role: "tablist", ->
								li role: "presentation", class: "nav-item", -> a class: "nav-link active", href: "#comments", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "comments", ->
									text "Comments "
									span class: "label label-pill label-default", "1"
								li role: "presentation", class: "nav-item", -> a class: "nav-link", href: "#changelog", role: "tab", ["data-toggle"]: "pill", ["aria-controls"]: "changelog", ->
									text "Changelog "
									span class:"label label-pill label-default", "200"
						div class: "row", ->
							div class: "tab-content", ->
								div role: "tabpanel", class: "tab-pane fade in active", id: "comments", -> @write_comments!
								div role: "tabpanel", class: "tab-pane fade", id: "changelog", -> @write_changelog!

		@content_for "post_body_script", ->
			script type: "text/javascript", -> raw "check_tablinks()"

	write_comments: =>
		paginated = @resource\get_comments_paginated per_page: 20
		comments = paginated\get_page 1
		ul ->
			li "#{paginated\num_pages!} pages. #{#comments} showing."

		for comment in *comments
			div class: "card-header", ->
				text "author here"
			div class: "card-block", ->
				text comment.message
		


	write_changelog: =>
		p "Changelog goes here."