import Widget from require "lapis.html"
import get_gravatar_url from require "utils"
import Users, UserFollowings from require "models"
db = require "lapis.db"

class MTAUserResources extends Widget
	@include require "widgets.utils"
	content: =>
		p "RESOURCESSS"
