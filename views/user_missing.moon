import Widget from require "lapis.html"

class MTAUserMissing extends Widget
	content: =>
		div class:"row", -> div class: "col-md-4 col-md-offset-4", ->
			h1 "#{@params.username}"
			h2 "Sorry, we don't know who or what you're talking about"