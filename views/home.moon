import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"
import ResourcePackages, Resources from require "models"

class Home extends Widget
	-- we have a jumbotron, so use content_for outer because we don't want a margin-top
	content: => @content_for "outer", ->
		div class: "jumbotron mta-home-jumbotron", -> div class: "container", ->
			p "Multi Theft Auto is a multiplayer modification for Rockstar's Grand Theft Auto game series: a piece of software that adapts the game in such a way, you can play Grand Theft Auto with your friends online and develop your own gamemodes."
			p "It was brought into life because of the lacking multiplayer functionality in the Grand Theft Auto series of games, and provides a completely new platform on-top of the original game, allowing for players to play all sorts and types of game-modes anywhere they want, and developers to develop using our very powerful scripting engine."
			p ->
				a class: "btn btn-primary", href: "https://mtasa.com", role: "button", "learn more"
				raw " "
				a class: "btn btn-primary", href: "/resources", role: "button", "browse resources"

		
		div class: "container", ->
			h2 "Latest Resources"

			-- Get the last 5 uploaded resource instances
			packageList = ResourcePackages\select "ORDER BY created_at DESC LIMIT 6"
			Resources\include_in packageList, "resource", as: "resource"

			div class: "row", ->
				local closedColumn
				for i, package in ipairs packageList
					resource = package.resource

					if (i-1)%2 == 0
						raw '<div class="col-md-4">'
						closedColumn = false

					div class: "card", ->
						div class: "card-header", ->
							a href: @url_for(resource), "#{resource.longname}"
							text " v#{package.version}"
							
						img  ["data-src"]: "/static/favicon.ico", alt: "Card image cap"
						div class: "card-footer", -> small class: "text-muted", " Last updated " .. time_ago_in_words package.created_at
					
					if (i-1)%2 == 1
						raw '</div>'
						closedColumn = true

				unless closedColumn
					raw "</div>"
