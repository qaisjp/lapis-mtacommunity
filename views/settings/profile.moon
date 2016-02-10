import Widget from require "lapis.html"

class MTASettingsProfile extends Widget
	name: "Profile"
	content: =>
		div class: "card", ->
			div class: "card-header", "Delete account"
			div class: "card-block", ->
				p "Deleting your account removes all resources, names from your comments, and screenshots. The username also becomes available for other people to register."
				
