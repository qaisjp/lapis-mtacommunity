lapis = require "lapis"
i18n  = require "i18n"

import generate_csrf_token from require "utils"
import Users from require "models"

-- We need to update the seed, otherwise math.random will always be the same
math.randomseed os.time!

languages = {
	en: true
	pi: true
}

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

		@active_user = Users\find @session.user_id	if @session.user_id
			
		if @active_user and @active_user\is_banned!
			@session.user_id = nil
			@active_user = nil

		-- this must be after @active_user
		@csrf_token = generate_csrf_token @

		-- language stuff now
		if newLocale = @params.set_locale
			print "ok"
			@cookies.locale = languages[newLocale] and newLocale or "en"
			@params.set_locale = nil

		locale = languages[@cookies.locale] and @cookies.locale or "en"
		i18n.loadFile "lang/#{locale}.lua"
		i18n.setLocale locale

	-- cookie_attributes: (name, value) =>
	-- 	base = "Path=/; HttpOnly"

	-- 	-- Have we been told to set the cookie expiry date?
	-- 	if expiry = @session.cookie_expiry
	-- 		base = "Expires=#{expiry}; {base}"
		
	-- 	base

	[home: "/"]: =>
		render: true

	["/test"]: =>