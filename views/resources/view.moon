import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import time_ago, time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcePage extends Widget
	content: =>
		div class: "row", ->
			div class: "card", ->
				div class: "card-header", ->
					h2 "#{@resource.longname} (#{@resource.name})"
				div class: "card-block", ->
					p "Body of card"