import Widget from require "lapis.html"

class Home extends Widget
	content: =>
		@content_for "outer", ->
			div class: "jumbotron mta-home-jumbotron", -> div class: "container", ->
				p "Multi Theft Auto is a multiplayer modification for Rockstar's Grand Theft Auto game series: a piece of software that adapts the game in such a way, you can play Grand Theft Auto with your friends online and develop your own gamemodes."
				p "It was brought into life because of the lacking multiplayer functionality in the Grand Theft Auto series of games, and provides a completely new platform on-top of the original game, allowing for players to play all sorts and types of game-modes anywhere they want, and developers to develop using our very powerful scripting engine."
				p ->
					a class: "btn btn-primary", href: "https://mtasa.com", role: "button", "learn more"
					raw " "
					a class: "btn btn-primary", href: "/resources", role: "button", "browse resources"

			
			div class: "container", ->
				h2 "Latest Resources"
				div class: "row", ->				
					for i = 0, 5
						if i%2 == 0
							raw '<div class="col-md-4">'

						div class: "card", ->
							div class: "card-header", ->
								text "guieditor 1.2.3.4"
								
							img  ["data-src"]: "/static/favicon.ico", alt: "Card image cap"
							div class: "card-footer", -> small class: "text-muted", " Last updated 3 mins ago"
						
						if i%2 == 1
							raw '</div>'
