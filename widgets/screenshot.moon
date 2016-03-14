import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"

class ScreenshotWidget extends Widget
	@include "widgets.utils"
	
	content: =>
		if not @screenshot then
			return p "Internal error: no screenshot passed to widget!"

		screenie_url = @url_for "resources.view_screenshot", resource_slug: @resource, screenie_id: @screenshot.id
		screenie_url_image = @url_for "resources.view_screenshot_image", resource_slug: @resource, screenie_id: @screenshot.id

		li class: "media", ->					
			div class: "media-body", ->
				h4 class: "media-heading", ->
					a href: screenie_url, @screenshot.title

					date_created = time_ago_in_words @screenshot.created_at
					small class: "text-muted", " uploaded #{date_created}"
				text @screenshot.description

			div class: "media-right", -> a href: screenie_url, ->
				img class: "media-object", width: 512, height: 256, src: screenie_url_image, alt: @screenshot.title