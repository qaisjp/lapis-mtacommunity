import Widget from require "lapis.html"

class Home extends Widget
	content: =>
		div class:"row", ->
			div class: "jumbotron", ->
				p "Multi Theft Auto is a multiplayer modification for Rockstar's Grand Theft Auto game series: a piece of software that adapts the game in such a way, you can play Grand Theft Auto with your friends online and develop your own gamemodes."
				p "It was brought into life because of the lacking multiplayer functionality in the Grand Theft Auto series of games, and provides a completely new platform on-top of the original game, allowing for players to play all sorts and types of game-modes anywhere they want, and developers to develop using our very powerful scripting engine."
				p ->
					a class: "btn btn-primary", href: "https://mtasa.com", role: "button", "learn more"
					raw " "
					a class: "btn btn-primary", href: "/resources", role: "button", "browse resources"

		div class: "row", ->
			h2 "latest resources"

		raw "<div class=row>"
		for i=1, 9
			div class: "col-md-4 home-resource-previews", -> div class: "media", ->
				div class: "media-left media-top", ->
					a href: "#", -> img class: "media-object", src: "#", alt: "..."
	
				div class: "media-body", ->
					h4 class: "media-heading", "guieditor 3.23.2"
					text "Bested thing ever!"
					p -> a class: "btn btn-default btn-sm", href: "#", role: "button", "View details »" -- » symbol = "&raquo;"

			-- This makes a new row every three previews
			if i % 3 == 0
				raw "</div><div class=row>"
		raw "</div>"