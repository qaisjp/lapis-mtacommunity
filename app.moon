lapis = require "lapis"

Users = require "models.users"

class extends lapis.Application
	layout: require "views.layout"

	@include "applications.users"
	
	[home: "/"]: =>
		render: true
		

	


