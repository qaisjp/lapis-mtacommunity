import Widget from require "lapis.html"
import time_ago_in_words from require "lapis.util"
i18n = require "i18n"

class ScreenshotWidget extends Widget
	@include "widgets.utils"
	
	content: =>
		if not @screenshot then
			return p "Internal error: no screenshot passed to widget!"

		screenie_url = @url_for "resources.view_screenshot", resource_slug: @screenshot.resource, screenie_id: @screenshot.id
		screenie_url_image = @screenshot\get_direct_url @

		element (@type or "div"), class: "media", ->					
			div class: "media-body", ->
				h4 class: "media-heading", ->
					a href: screenie_url, @screenshot.title

					date_created = time_ago_in_words @screenshot.created_at
					small class: "text-muted", " #{i18n 'screenshots.uploaded_since'} #{date_created}"
				text @screenshot.description


			screenie_href = (@route_name == "resources.view_screenshot") and screenie_url_image or screenie_url
			div class: "media-right", -> a href: screenie_href, ->
				img class: "media-object", width: 512, height: 256, src: screenie_url_image, alt: @screenshot.title