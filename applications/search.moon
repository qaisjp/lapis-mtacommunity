lapis = require "lapis"
import trim_filter from require "lapis.util"

class SearchApplication extends lapis.Application
	[search: "/search"]: =>
		trim_filter @params
		render: true			