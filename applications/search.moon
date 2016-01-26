lapis = require "lapis"
import Resources from require "models"
import trim_filter from require "lapis.util"

class SearchApplication extends lapis.Application
	[search: "/search"]: =>
		trim_filter @params
		@resourceList = Resources\select "ORDER BY downloads DESC LIMIT 15"
		render: true			