import Widget from require "lapis.html"
date = require "date"
i18n = require "i18n"
class MTAResourceManageAuthors extends Widget
	@include "widgets.utils"

	name: "Authors"
	breadcrumb: =>
		li @author.name if @author

	content: =>
		unless @active_user.id == @resource.creator
			div class: "alert alert-warning", role: "alert", ->
				strong "#{i18n 'warning'} "
				text i18n "resources.manage.author_delete_self"

		@output_errors!

		if @author
			div class: "card", ->
				div class: "card-header", ->
					text i18n "resources.manage.author_own_permissions", name: @author.username
					small class: "text-muted", " #{i18n 'resources.manage.author_perm_dashboard_note'}"

				div class: "card-block", ->

					rights = @author_rights
					form class: "mta-inline-form form-inline", method: "POST", action: @url_for("resources.manage.update_author_rights", resource_slug: @resource), ->
						element "table", class: "table table-hover table-bordered table-sm mta-card-table", ->
							thead ->
								th i18n "resources.manage.author_right"
								th i18n "resources.manage.author_right_value"
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
						button type: "submit", class: "btn btn-primary", onclick: "return confirm(\"#{i18n 'are_you_sure'}\")", ->
							text i18n "resources.manage.author_update_perms_button"

					raw " "

					form class: "mta-inline-form", method: "POST", action: @url_for("resources.manage.delete_author", resource_slug: @resource), ->
						@write_csrf_input!
						input type: "hidden", name: "author", value: @author.slug, ["aria-hidden"]: "true"
						button type: "submit", class: "btn btn-secondary btn-danger", onclick: "return confirm(\"#{i18n 'author_delete_confirm'}\")", ->
							text i18n "resources.manage.author_delete_button"


		else
			list_authors = (headerText, missingText, rows) ->
				div class: "card", ->
					div class: "card-header", headerText
					div class: "card-block", ->
						return text missingText if #rows == 0
						element "table", class: "table table-href table-hover table-bordered mta-card-table", ->
							thead ->
								th i18n "settings.username"
								th i18n "since"
							tbody ->
								for manager in *rows
									url = @url_for "resources.manage.authors", resource_slug: @resource, author: manager.slug
									tr ["data-href"]: url, ->
										td ->
											a href: @url_for(manager), manager.username
										td ->
											text date(manager.created_at)\fmt "${rfc1123} "
											a class: "btn btn-sm btn-secondary pull-xs-right", href: url, -> i class: "fa fa-cogs"

			list_authors i18n("resources.manage.authors_list"), i18n("resources.manage.authors_list_empty"), @resource\get_authors include_creator: false, is_confirmed: true
			list_authors i18n("resources.manage.authors_invited"), i18n("resources.manage.authors_invited_empty"), @resource\get_authors include_creator: false, is_confirmed: false

			div class: "card", ->
				div class: "card-header", i18n("resources.manage.author_make_invite")
				div class: "card-block", -> form action: @url_for("resources.manage.invite_author", resource_slug: @resource), method: "POST", ->
					@write_csrf_input!
					fieldset class: "form-group row", ->
						label class: "col-sm-2", for: "inviteAuthor", i18n "settings.username"
						div class: "col-sm-10", ->
							input type: "text", class: "form-control", id: "inviteAuthor", name: "author"

					div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", onclick: "return confirm('Are you sure?')", i18n "resources.manage.author_invite_button"
					