import Widget from require "lapis.html"
date = require "date"

class MTAResourceManageManagers extends Widget
	@include "widgets.utils"

	name: "Authors"
	content: =>
		div class: "alert alert-warning", role: "alert", ->
			strong "Warning!"
			text " Unless you are the owner of this resource, you can remove your own access to this page. Be careful."

		if @author
			div class: "card", ->
				div class: "card-header", ->
					text "Their permissions"

				div class: "card-block", ->
					-- for now just use our rights
					rights = @rights
					element "table table-bordered table-hover mta-card-table", class: "table", ->
						thead ->
							th "right"
							th "value"
						tbody ->
							for right in *{"configure", "moderate", "manage_managers", "manage_packages", "upload_screenshots"}							
								tr ->
									td "can_#{right}"
									td tostring rights["can_#{right}"]
		else
			div class: "card", ->
				div class: "card-header", "List of authors"
				div class: "card-block", ->
					element "table", class: "table table-href table-hover table-bordered mta-card-table", ->
						thead ->
							th "username"
							th "since"
							-- th ""
						tbody ->
							for manager in *@resource\get_authors nil, false
								url = "?author=#{manager.slug}"
								tr ["data-href"]: url, ->
									td ->
										a href: @url_for(manager), manager.username
									td ->
										text date(manager.created_at)\fmt "${rfc1123} "
										a class: "btn btn-sm btn-secondary pull-xs-right", href: url, -> i class: "fa fa-cogs"
