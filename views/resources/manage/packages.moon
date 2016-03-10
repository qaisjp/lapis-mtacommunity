import Widget from require "lapis.html"
import Comments from require "models"
db = require "lapis.db"

class MTAResourceManagePackages extends Widget
	@include "widgets.utils"

	name: "Packages"
	content: =>
		p -> button type: "button", class: "btn btn-primary", ["data-toggle"]: "collapse", ["data-target"]: "#upload", ["aria-expanded"]: "false", ["aria-controls"]: "upload", "Show upload form"
	
		div class: "collapse", id: "upload", ->
			div class: "card card-block", ->
				form method: "POST", enctype: "multipart/form-data", ->
					fieldset class: "form-group", ->
						label for: "uploadChangelog", ->
							text "Changelog "
							small class: "text-muted", "What does this update do? What has changed?"
						textarea class: "form-control", id: "uploadChangelog", name: "uploadChangelog", rows: 3, required: true, @params.uploadChangelog

					input type: "file", id: "uploadFile", required: true
					button type: "submit", class: "btn btn-secondary btn-sm", ->
						i class: "fa fa-upload"
						text " Upload"


		div class: "card", ->
			div class: "card-header", ->
				text "Packages"
			div class: "card-block", ->
				element "table", class: "table table-hover table-bordered table-href", ->
					thead ->
						th "version"
						th "tools"
					tbody ->
						