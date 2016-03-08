import Widget from require "lapis.html"
date = require "date"

class MTAResourceManageManagers extends Widget
	@include "widgets.utils"

	name: "Authors"
	content: =>
		div class: "alert alert-warning", role: "alert", ->
			strong "Warning!"
			text " Unless you are the owner of this resource, you can remove your own access to this page. Be careful."

		@output_errors!

		if @author
			div class: "card", ->
				div class: "card-header", ->
					text "#{@author.username}'s permissions"

				div class: "card-block", ->
					rights = @author_rights
					form class: "mta-inline-form form-inline", method: "POST", action: @url_for("resources.manage.update_author_rights", resource_slug: @resource), ->
						element "table", class: "table table-hover table-bordered mta-card-table", ->
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
			div class: "card", ->
				div class: "card-header", "List of authors"
				div class: "card-block", ->
					element "table", class: "table table-href table-hover table-bordered mta-card-table", ->
						thead ->
							th "username"
							th "since"
						tbody ->
							for manager in *@resource\get_authors nil, false
								url = @url_for "resources.manage.authors", resource_slug: @resource, author: manager.slug
								tr ["data-href"]: url, ->
									td ->
										a href: @url_for(manager), manager.username
									td ->
										text date(manager.created_at)\fmt "${rfc1123} "
										a class: "btn btn-sm btn-secondary pull-xs-right", href: url, -> i class: "fa fa-cogs"
