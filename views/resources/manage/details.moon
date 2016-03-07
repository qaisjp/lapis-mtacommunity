import Widget from require "lapis.html"

class MTAResourceManageDetails extends Widget
	@include "widgets.utils"

	name: "Details"
	content: =>
		div class: "card", ->
			div class: "card-header", "Change description"
			div class: "card-block", -> form method: "POST", ->
				fieldset class: "form-group", ->
					label for: "resDescription", ->
						text "Description "
						small class: "text-muted", "This will be displayed whenever people visit your resource."
					textarea class: "form-control", id: "resDescription", name: "resDescription", rows: 3, required: true, @resource.description

				@write_csrf_input!
				button class: "btn btn-secondary", type: "submit", " Update description"

		div class: "card", ->
			div class: "card-header", "Change owner"
			div class: "card-block", -> --form action: @url_for("resource.manage.transfer_ownership"), method: "POST", ->
				@write_csrf_input!

				p "You will no longer have access to the management section of this resource. You will have to contact the new owner to be given permissions."
				fieldset class: "form-group row", ->
					label class: "col-sm-2", for: "settingsNewOwner", "New owner"
					div class: "col-sm-10", ->
						input type: "text", class: "form-control", id: "settingsNewOwner", name: "settingsNewOwner"

				div class: "form-group row", ->
					div class: "col-sm-offset-2 col-sm-10", ->
						button type: "submit", class: "btn btn-secondary", onclick: "return confirm('Are you sure you want to change transfer owernship?')", "Transfer ownership..."

		div class: "card", ->
			div class: "card-header bg-danger", "Delete resource"
			div class: "card-block", ->
				p "Deleting your resources removes all comments, screenshots and packages. The resource also becomes available for other people to register."

				form ->--action: @url_for("resource.manage.delete"), method: "POST", ->
					@write_csrf_input!
					button class: "btn btn-primary btn-danger", type: "submit", onclick: "return confirm('Are you sure you want to delete this resource? This is permanent.')", " Delete resource..."