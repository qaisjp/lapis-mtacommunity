import Widget from require "lapis.html"
import ResourcePackages from require "models"
date = require "date"
db = require "lapis.db"

class MTAResourceManageSinglePackage extends Widget
	@include "widgets.utils"

	name: "Packages"
	content: =>
		div class: "card", ->
			div class: "card-header", ->
				text "Packages"
			div class: "card-block", ->
				text @package.id