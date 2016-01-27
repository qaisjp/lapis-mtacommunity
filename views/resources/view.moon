import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import time_ago, time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcePage extends Widget
	content: =>
		h1 "Resource: "

		div class: "container", ->
			div class: "row", ->
				p "Row content"