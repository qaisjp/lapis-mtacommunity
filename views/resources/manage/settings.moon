import Widget from require "lapis.html"

class MTAResourceManageSettings extends Widget
	@include "widgets.utils"

	name: "Settings"
	content: =>
		div class: "card", ->
			div class: "card-header", "Manage managers"
			div class: "card-block", ->

		div class: "card", ->
			div class: "card-header", "Transfer ownership"
			div class: "card-block", -> form action: @url_for("resources.manage.transfer_ownership", resource_slug: @resource), method: "POST", ->
				@write_csrf_input!

				p "You will no longer have access to the management section of this resource. You will have to contact the new owner to be given permissions."
				div class: "form-group row", ->
					label class: "col-sm-2", "New owner"
					div class: "col-sm-10", ->
						input type: "text", class: "form-control", name: "settingsNewOwner"

				div class: "form-group row", ->
					div class: "col-sm-offset-2 col-sm-10", ->
						button type: "submit", class: "btn btn-secondary", onclick: "return confirm('Are you sure you want to change transfer owernship?')", "Transfer ownership..."

		div class: "card", ->
			div class: "card-header", "Rename resource"
			div class: "card-block", -> form action: @url_for("resources.manage.rename", resource_slug: @resource), method: "POST", ->
				@write_csrf_input!

				p "The old resource name becomes available for other people to register. No redirections will be set up."
				p "Any existing resources that include your resource will still include your resource for download. These resources will need to be updated to include the new name."
				p "Any newly uploaded resources should have the updated name."

				div class: "form-group row", ->
					label class: "col-sm-2", "Name"
					div class: "col-sm-10", ->
						input type: "text", class: "form-control", name: "settingsNewResourceName", value: @resource.name

				div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", onclick: "return confirm('Are you sure you want to rename your resource?')", "Rename resource..."

		div class: "card", ->
			div class: "card-header bg-danger", "Delete resource"
			div class: "card-block", ->
				p "Deleting your resources removes all comments, screenshots and packages. The resource also becomes available for other people to register."

				form action: @url_for("resources.manage.delete", resource_slug: @resource), method: "POST", ->
					@write_csrf_input!
					button class: "btn btn-primary btn-danger", type: "submit", onclick: "return confirm('Are you sure you want to delete this resource? This is permanent.')", " Delete resource..."
