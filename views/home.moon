import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"
import ResourcePackages, Resources from require "models"
i18n = require "i18n"

class Home extends Widget
	-- we have a jumbotron, so use content_for outer because we don't want a margin-top
	content: => @content_for "outer", ->
		div class: "jumbotron mta-home-jumbotron", -> div class: "container", ->
			p i18n "homepage.main.first"
			p i18n "homepage.main.second"
			p ->
				a class: "btn btn-primary", href: "https://mtasa.com", role: "button", i18n "homepage.learn_more"
				raw " "
				a class: "btn btn-primary", href: "/resources", role: "button", i18n "homepage.browse_resources"

		
		div class: "container", ->
			h2 i18n 'resources.latest_resources'

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
						div class: "card-footer", -> small class: "text-muted", " #{i18n 'resources.cards.last_updated'} " .. time_ago_in_words package.created_at
					
					if (i-1)%2 == 1
						raw '</div>'
						closedColumn = true

				unless closedColumn
					raw "</div>"
