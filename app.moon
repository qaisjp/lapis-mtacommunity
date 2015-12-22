lapis = require "lapis"

import generate_csrf_token from require "utils"

-- We need to update the seed, otherwise math.random will always be the same
math.randomseed os.time!

class extends lapis.Application
	layout: require "views.layout"

	@include "applications.auth"
	
	@before_filter =>
		@csrf_token = generate_csrf_token @

	[home: "/"]: =>
		render: true
		