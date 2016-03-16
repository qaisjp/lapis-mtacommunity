import Widget from require "lapis.html"
import Users, Resources, ResourcePackages, ResourceRatings from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"
i18n = require "i18n"

class MTAResourceLayout extends Widget
	@include "widgets.utils"
	content: =>
		if @rights and not @rights.user_confirmed
			div class: "alert alert-info", role: "alert", ->
				strong i18n "resources.manage.author.moderation_invite"
				raw " "
				form class: "mta-inline-form", method: "POST", action: @url_for("resources.manage.invite_reply", resource_slug: @resource), ->
					@write_csrf_input!
					button type: "submit", class: "btn btn-secondary btn-sm", name: "accept_state", value: "true", ->
						text i18n "resources.manage.author.accept_invite"
					raw " "
					button type: "submit", class: "btn btn-secondary btn-sm", name: "accept_state", value: "false", ->
						text i18n "resources.manage.author.decline_invite"

		div class: "row", ->
			div class: "card", ->
				div class: "card-header", ->
					h2 ->
						text "#{@resource.longname} (#{@resource.name}) "
						span class: "label label-primary", Resources.types[@resource.type]

						span class: "pull-xs-right", ->
							if @rights and @rights.user_confirmed
								a class: "btn btn-secondary", href: @url_for("resources.manage.dashboard", resource_slug: @resource), ->
									i class: "fa fa-cogs"
									raw " "
									text i18n "resources.manage.title"
								raw " "

							if @route_name == "resources.view"
								if @active_user
									form method: "POST", action: @url_for("resources.cast_vote", resource_slug: @resource), class: "mta-inline-form", ->
										@write_csrf_input!
										rating = ResourceRatings\find resource: @resource.id, user: @active_user.id
										rating = rating.rating if rating

										span class: "btn-group", role: "group", ["aria-label"]: i18n("resources.cast_vote"), ->
											button type: "submit", name: "vote", value: "down", class: {"btn btn-secondary", active: (rating == false)}, ->
												i class: "fa fa-thumbs-down"
											button type: "submit", name: "vote", value: "none", class: {"btn btn-secondary", active: (rating == nil)}, ->
												i class: "fa fa-circle"
											button type: "submit", name: "vote", value: "up", class: {"btn btn-secondary", active: (rating == true)}, ->
												i class: "fa fa-thumbs-up"
									raw " "

								a class: "btn btn-primary", href: @url_for("resources.get", resource_slug: @resource), ->
									i class: "fa fa-download"
									raw " "
									text i18n "download"
							else
								raw " "
								a class: "btn btn-secondary", href: @url_for("resources.view", resource_slug: @resource), ->
									i class: "fa fa-arrow-left"
									raw " "
									text i18n "resources.view_resource"


				
				viewWidget = require "views." .. @route_name
				widget viewWidget
				