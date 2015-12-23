lapis = require "lapis"

class AdminApplication extends lapis.Application
	["admin.home": "/admin"]: =>
		render: true
	