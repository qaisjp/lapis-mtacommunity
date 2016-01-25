lapis = require "lapis"

import generate_csrf_token from require "utils"

-- We need to update the seed, otherwise math.random will always be the same
math.randomseed os.time!

Users = require "models.users"

class MTAApp extends lapis.Application
	layout: require "views.layout"

	@include "applications.admin"
	@include "applications.auth"
	@include "applications.resource"
	@include "applications.settings"
	@include "applications.search"
	@include "applications.user"
	
	@before_filter =>
		@csrf_token = generate_csrf_token @
		@active_user = Users\find @session.user_id if @session.user_id

	-- cookie_attributes: (name, value) =>
	-- 	base = "Path=/; HttpOnly"

	-- 	-- Have we been told to set the cookie expiry date?
	-- 	if expiry = @session.cookie_expiry
	-- 		base = "Expires=#{expiry}; {base}"
		
	-- 	base

	[home: "/"]: =>
		render: true