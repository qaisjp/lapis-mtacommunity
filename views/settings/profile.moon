import Widget from require "lapis.html"
db = require "lapis.db"

class MTASettingsProfile extends Widget
	@include "widgets.utils"

	name: "Profile"
	content: =>
		div class: "card", ->
			div class: "card-header", "Account"
			div class: "card-block", ->
				form method: "POST", ->
					@write_csrf_input!
					
					div class: "form-group row", ->
						label class: "col-sm-2", -> abbr title: "This only affects your profile page. Everyone will be able to see your comments and see in others' list that they follow you.", "Privacy"
						div class: "col-sm-10", ->
							div class: "radio", -> label ->
								input type: "radio", name: "settingsPrivacy", value: "1", checked: @data.privacy_mode == 1
								text " Public"
							div class: "radio", -> label ->
								input type: "radio", name: "settingsPrivacy", value: "2", checked: @data.privacy_mode == 2
								text " Following Only"

					div class: "form-group row", ->
						label class: "col-sm-2", "Birthday"
						div class: "col-sm-10", ->
							input type: "date", class: "form-control", name: "settingsDate", value: (@data.birthday == db.NULL) and "" or @data.birthday

					div class: "form-group row", ->
						label class: "col-sm-2", "Gang"
						div class: "col-sm-10", ->
							input type: "text", class: "form-control", name: "settingsGang", maxlength: 255, value: (@data.gang == db.NULL) and "" or @data.gang

					div class: "form-group row", ->
						label class: "col-sm-2", "Location"
						div class: "col-sm-10", ->
							input type: "text", class: "form-control", name: "settingsLocation", maxlength: 255, value: (@data.location == db.NULL) and "" or @data.location

					div class: "form-group row", ->
						label class: "col-sm-2", "Website"
						div class: "col-sm-10", ->
							input type: "text", class: "form-control", name: "settingsWebsite", maxlength: 255, value: (@data.website == db.NULL) and "" or @data.website

					div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", "Update Section"