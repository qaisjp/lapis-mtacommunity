import Widget from require "lapis.html"
import Users, Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcePage extends Widget
	@include "widgets.utils"
	content: => div class: "card-block", ->
		screenie_url_image = @url_for "resources.view_screenshot_image", resource_slug: @resource, screenie_id: @screenshot.id
		img class: "media-object", width: 512, height: 256, src: screenie_url_image, alt: @screenshot.title