import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcesUpload extends Widget
	content: =>
		h1 "Upload a new resource"
		div class: "alert alert-info", role: "alert", "If you'd like to update an existing resource, visit the manager for the resource."

		raw "The following attributes are read from your <strong>meta.xml</strong>'s' <code>info</code> field:"
		ul ->
			li -> raw "version - in the format of <code>X</code>, <code>X.X</code>, or <code>X.X.X</code>"
			li -> raw "name - for the 'descriptive name'" 
			li -> raw "type (<code>gamemode</code>, <code>script</code>, <code>map</code>, or <code>misc</code>)"

		if @errors and #@errors > 0
			div class: "alert alert-danger", role: "alert", ->
				ul -> for err in *@errors do li err

		form method: "POST", enctype: "multipart/form-data", ->
			div class: "card", ->
				div class: "card-header", "Details"
				div class: "card-block", ->
					fieldset class: "form-group", ->
						label for: "resName", ->
							text "Name "
							small class: "text-muted", "The name of the resource file (admin, editor, freeroam, race, hedit, etc.)"
						input type: "text", class: "form-control", id: "resName", name: "resName", value: @params.resName, required: true
						
					
					fieldset class: "form-group", ->
						label for: "resDescription", ->
							text "Description "
							small class: "text-muted", "This will be displayed whenever people visit your resource."
						textarea class: "form-control", id: "resDescription", name: "resDescription", rows: 3, required: true, @params.resDescription
			
				div class: "card-footer form-inline", ->
					input type: "file", name: "resUpload", required: true
			
			button type: "submit", class: "btn btn-primary", "Publish Resource"