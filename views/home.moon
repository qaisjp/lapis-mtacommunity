import Widget from require "lapis.html"

class Home extends Widget
	content: =>
		
		div class:"row", ->
			div class: "jumbotron", ->
				p "Multi Theft Auto is a multiplayer modification for Rockstar's Grand Theft Auto game series: a piece of software that adapts the game in such a way, you can play Grand Theft Auto with your friends online and develop your own gamemodes."
				p "It was brought into life because of the lacking multiplayer functionality in the Grand Theft Auto series of games, and provides a completely new platform on-top of the original game, allowing for players to play all sorts and types of game-modes anywhere they want, and developers to develop using our very powerful scripting engine."

		div class: "row", ->
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