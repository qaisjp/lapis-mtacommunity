import Widget from require "lapis.html"
import Users, Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourceManage extends Widget
	@include "widgets.utils"
	content: =>
		div class: "card", ->
			div class: "card-header", ->
				text "Manage #{@resource.longname} (#{@resource.name})"

			div class: "card-block", ->
				p "buttons"

			div class: "card-block", ->
				p "content"