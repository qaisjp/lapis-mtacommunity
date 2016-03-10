import Widget from require "lapis.html"
date = require "date"

class MTAResourceManageAuthors extends Widget
	@include "widgets.utils"

	name: "Authors"
	breadcrumb: =>
		li @author.name if @author

	content: =>
		unless @active_user.id == @resource.creator
			div class: "alert alert-warning", role: "alert", ->
				strong "Warning!"
				text " If you delete yourself as an author, you won't be able to use this page anymore. Be careful."

		@output_errors!

		if @author
			div class: "card", ->
				div class: "card-header", ->
					text "#{@author.username}'s permissions "
					small class: "text-muted", "All authors can view the resource dashboard"

				div class: "card-block", ->

					rights = @author_rights
					form class: "mta-inline-form form-inline", method: "POST", action: @url_for("resources.manage.update_author_rights", resource_slug: @resource), ->
						element "table", class: "table table-hover table-bordered table-sm mta-card-table", ->
							thead ->
								th "right"
								th "value"
							tbody ->
								for right in *@right_names
									right_value = rights[right]
									tr ->
										td ->
											input type: "checkbox", class: "checkbox", checked: right_value, disabled: true
											text " #{right}"
										td -> input type: "checkbox", class: "checkbox", name: right, value: "true", checked: right_value

						br!
						@write_csrf_input!
						input type: "hidden", name: "author", value: @author.slug, ["aria-hidden"]: "true"
						button type: "submit", class: "btn btn-primary", onclick: "return confirm('Are you sure?')", ->
							text "Update permissions"

					raw " "

					form class: "mta-inline-form", method: "POST", action: @url_for("resources.manage.delete_author", resource_slug: @resource), ->
						@write_csrf_input!
						input type: "hidden", name: "author", value: @author.slug, ["aria-hidden"]: "true"
						button type: "submit", class: "btn btn-secondary btn-danger", onclick: "return confirm('Are you sure you want to remove this user as an author?')", ->
							text "Delete author"


		else
			list_authors = (headerText, missingText, rows) ->
				div class: "card", ->
					div class: "card-header", headerText
					div class: "card-block", ->
						return text missingText if #rows == 0
						element "table", class: "table table-href table-hover table-bordered mta-card-table", ->
							thead ->
								th "username"
								th "since"
							tbody ->
								for manager in *rows
									url = @url_for "resources.manage.authors", resource_slug: @resource, author: manager.slug
									tr ["data-href"]: url, ->
										td ->
											a href: @url_for(manager), manager.username
										td ->
											text date(manager.created_at)\fmt "${rfc1123} "
											a class: "btn btn-sm btn-secondary pull-xs-right", href: url, -> i class: "fa fa-cogs"

			list_authors "List of authors", "This resource has no co-authors.", @resource\get_authors include_creator: false, is_confirmed: true
			list_authors "Invited authors", "This resource has no pending invites for authorship.", @resource\get_authors include_creator: false, is_confirmed: false

			div class: "card", ->
				div class: "card-header", "Invite author"
				div class: "card-block", -> form action: @url_for("resources.manage.invite_author", resource_slug: @resource), method: "POST", ->
					@write_csrf_input!
					fieldset class: "form-group row", ->
						label class: "col-sm-2", for: "inviteAuthor", "Username"
						div class: "col-sm-10", ->
							input type: "text", class: "form-control", id: "inviteAuthor", name: "author"

					div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", onclick: "return confirm('Are you sure?')", "Invite..."
					