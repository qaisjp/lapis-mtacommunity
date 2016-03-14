import Widget from require "lapis.html"
import Users, Resources, ResourcePackages from require "models"
import time_ago_in_words from require "lapis.util"
date = require "date"

class MTAResourcePage extends Widget
	@include "widgets.utils"
	content: => div class: "card-block", ->
		widget require("widgets.screenshot") screenshot: @screenshot