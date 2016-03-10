import Widget from require "lapis.html"
import Comments from require "models"
db = require "lapis.db"

class MTAResourceManagePackages extends Widget
	@include "widgets.utils"

	name: "Packages"
	content: =>		
		div class: "card", ->
			div class: "card-header", ->
				text "Packages"
				a class: "btn btn-secondary btn-sm pull-xs-right", ->
					i class: "fa fa-upload"
					text "Upload"

			div class: "card-block", ->
				element "table", class: "table table-hover table-bordered table-sm table-href"