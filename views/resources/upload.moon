import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"
i18n = require "i18n"

class MTAResourcesUpload extends Widget
	@include "widgets.utils"
	content: =>
		h1 i18n "resources.upload.title"
		div class: "alert alert-info", role: "alert", i18n "resources.upload.existing_update_alert"

		raw "The following attributes are read from your <strong>meta.xml</strong>'s' <code>info</code> field:"
		ul ->
			li -> raw "version - in the format of <code>X</code>, <code>X.X</code>, or <code>X.X.X</code>"
			li -> raw "name - for the 'descriptive name'" 
			li -> raw "type (<code>gamemode</code>, <code>script</code>, <code>map</code>, or <code>misc</code>)"

		@output_errors!

		form method: "POST", enctype: "multipart/form-data", ->
			div class: "card", ->
				div class: "card-header", i18n "resources.manage.details.title"
				div class: "card-block", ->
					fieldset class: "form-group", ->
						label for: "resName", ->
							text i18n "resources.table.name"
							raw " "
							small class: "text-muted", i18n "resources.upload.name_info"
						input type: "text", class: "form-control", id: "resName", name: "resName", value: @params.resName, required: true
						
					
					fieldset class: "form-group", ->
						label for: "resDescription", ->
							text i18n "resources.table.description"
							raw " "
							small class: "text-muted", i18n "resources.upload.description_info"
						textarea class: "form-control", id: "resDescription", name: "resDescription", rows: 3, required: true, @params.resDescription
			
				div class: "card-footer form-inline", ->
					input type: "file", name: "resUpload", required: true
			
			button type: "submit", class: "btn btn-primary", i18n "resources.upload.publish"