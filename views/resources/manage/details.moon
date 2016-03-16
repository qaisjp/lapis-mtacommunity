import Widget from require "lapis.html"
i18n = require "i18n"

class MTAResourceManageDetails extends Widget
	@include "widgets.utils"

	name: "Details"
	content: =>
		div class: "card", ->
			div class: "card-header", i18n "resources.manage.details.change_description"
			div class: "card-block", -> form method: "POST", action: @url_for("resources.manage.update_description", resource_slug: @resource.slug), ->
				fieldset class: "form-group", ->
					label for: "resDescription", ->
						text "#{i18n 'resources.manage.details.description'} "
						small class: "text-muted", i18n "resources.manage.details.description_info"
					textarea class: "form-control", id: "resDescription", name: "resDescription", rows: 3, required: true, @resource.description

				@write_csrf_input!
				button class: "btn btn-secondary", type: "submit", " #{i18n 'resources.manage.details.description_button'}"