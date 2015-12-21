import Widget from require "lapis.html"

class Home extends Widget
	content: =>
		h1 "We are inner!!"
		div class: "col-md-4", ->
			h2 "Heading"
			p "Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui."
			p -> a class: "btn btn-default", href: "#", role: "button", "View details »"
	   
		div class: "col-md-4", ->
			h2 "Heading"
			p "Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. "
			p -> a class: "btn btn-default", href: "#", role: "button", "View details »"
		
		div class: "col-md-4", ->
			h2 "Heading"
			p "Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Vestibulum id ligula porta felis euismod semper. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus."
			p -> a class: "btn btn-default", href: "#", role: "button", "View details »"