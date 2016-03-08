import Widget from require "lapis.html"

class MTAResourceManageDetails extends Widget
	@include "widgets.utils"

	name: "Details"
	content: =>
		div class: "card", ->
			div class: "card-header", "Change description"
			div class: "card-block", -> form method: "POST", action: @url_for("resources.manage.update_description", resource_slug: @resource.slug), ->
				fieldset class: "form-group", ->
					label for: "resDescription", ->
						text "Description "
						small class: "text-muted", "This will be displayed whenever people visit your resource."
					textarea class: "form-control", id: "resDescription", name: "resDescription", rows: 3, required: true, @resource.description

				@write_csrf_input!
				button class: "btn btn-secondary", type: "submit", " Update description"