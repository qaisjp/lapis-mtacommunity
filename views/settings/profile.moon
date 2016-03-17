import Widget from require "lapis.html"
db   = require "lapis.db"
i18n = require "i18n"
class MTASettingsProfile extends Widget
	@include "widgets.utils"

	category: "profile"
	content: =>
		div class: "card", ->
			div class: "card-header", i18n "settings.profile"
			div class: "card-block", ->
				form method: "POST", ->
					@write_csrf_input!
					
					div class: "form-group row", ->
						label class: "col-sm-2", -> abbr title: i18n("settings.privacy_note"), i18n "settings.privacy"
						div class: "col-sm-10", ->
							div class: "radio", -> label ->
								input type: "radio", name: "settingsPrivacy", value: "1", checked: @data.privacy_mode == 1
								raw " "
								text i18n "settings.public"
							div class: "radio", -> label ->
								input type: "radio", name: "settingsPrivacy", value: "2", checked: @data.privacy_mode == 2
								raw " "
								text i18n "settings.following_only"

					div class: "form-group row", ->
						label class: "col-sm-2", i18n "users.cakeday"
						div class: "col-sm-10", ->
							input type: "date", class: "form-control", name: "settingsDate", value: (@data.birthday == db.NULL) and "" or @data.birthday

					div class: "form-group row", ->
						label class: "col-sm-2", i18n "users.gang"
						div class: "col-sm-10", ->
							input type: "text", class: "form-control", name: "settingsGang", maxlength: 255, value: (@data.gang == db.NULL) and "" or @data.gang

					div class: "form-group row", ->
						label class: "col-sm-2", i18n "users.location"
						div class: "col-sm-10", ->
							input type: "text", class: "form-control", name: "settingsLocation", maxlength: 255, value: (@data.location == db.NULL) and "" or @data.location

					div class: "form-group row", ->
						label class: "col-sm-2", i18n "users.website"
						div class: "col-sm-10", ->
							input type: "text", class: "form-control", name: "settingsWebsite", maxlength: 255, value: (@data.website == db.NULL) and "" or @data.website

					div class: "form-group row", ->
						div class: "col-sm-offset-2 col-sm-10", ->
							button type: "submit", class: "btn btn-secondary", i18n "settings.update_section"