lapis = require "lapis"

import generate_csrf_token from require "utils"
import Users from require "models"

-- We need to update the seed, otherwise math.random will always be the same
math.randomseed os.time!

class MTAApp extends lapis.Application
	-- Import the base layout for the entire application
	layout: require "views.layout"

	-- Include all the sub-applications
	@include "applications.admin"
	@include "applications.auth"
	@include "applications.resource"
	@include "applications.settings"
	@include "applications.search"
	@include "applications.user"
	
	@before_filter =>
		-- load a logged in user from the db
		@active_user = Users\find @session.user_id if @session.user_id

		-- this must be after @active_user
		@csrf_token = generate_csrf_token @

	-- cookie_attributes: (name, value) =>
	-- 	base = "Path=/; HttpOnly"

	-- 	-- Have we been told to set the cookie expiry date?
	-- 	if expiry = @session.cookie_expiry
	-- 		base = "Expires=#{expiry}; {base}"
		
	-- 	base

	[home: "/"]: =>
		render: true

	["/test"]: =>