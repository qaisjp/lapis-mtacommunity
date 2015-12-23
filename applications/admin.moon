lapis = require "lapis"

class AdminApplication extends lapis.Application
	path: "/admin"
	name: "admin."

	@before_filter =>
		print "Okay, well the before filter is being called..."

	[home: ""]: =>
		render: "admin.layout"
	
	[users: "/users"]: => render: "admin.layout"
	[bans: "/bans"]: => render: "admin.layout"