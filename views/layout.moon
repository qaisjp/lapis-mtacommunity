import Widget from require "lapis.html"
Users = require "models.users"
i18n = require "i18n"


class Layout extends Widget
	content: => html_5 ->
		head ->
			meta charset: "utf-8"
			meta ["http-equiv"]: "X-UA-Compatible", content: "IE=edge"
			meta name: "viewport", content: "width=device-width, initial-scale=1"
			-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags 

			meta name: "description", content: "The Multi Theft Auto Community Website"
			link rel: "icon", href: @build_url "favicon.ico"
			
			if @title
				title (@title .. " - MTA Community")
			else
				title "Multi Theft Auto Community"

			-- Font Awesome icons
			link href: "/vendor/font-awesome/css/font-awesome.css", rel: "stylesheet"
			
			-- Bootstrap core CSS
			link href: "/vendor/bootstrap/dist/css/bootstrap.css", rel: "stylesheet"

			-- Custom styles
			link href: "/static/css/main.css", rel: "stylesheet"

			-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries
			raw "<!--[if lt IE 9]>"
			script src: "https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"
			script src: "https://oss.maxcdn.com/respond/1.4.2/respond.min.js"
			raw "<![endif]-->"

			@content_for "head_extra"

		body ->
			@render_navbar!
		
			@content_for "outer"
			if @has_content_for "inner"
				div class: "container mta-content", ->					
					@content_for "inner"
			
			div class: "container", ->
				hr!
				@render_footer!


			-- Bootstrap core JavaScript
			-- Placed at the end of the document so the pages load faster
			script src: "/vendor/jquery/dist/jquery.js"
			script src: "/vendor/bootstrap/dist/js/bootstrap.js"

			
			-- IE10 viewport hack for Surface/desktop Windows 8 bug
			script src: "/static/js/ie10-viewport-bug-workaround.js"

			-- Now finally, our own code!
			script src: "/static/js/main.js"

			script src: "/static/js/anchor-handling.js"

			@content_for "post_body_script"
		-- /body
	--/html

	render_navbar: =>
		nav class: "navbar navbar-dark bg-inverse navbar-fixed-top", -> div class: "container", ->
			a class: "navbar-brand", href: "/", "mta community"
			
			ul class: "nav navbar-nav mta-navbar-links", ->
				li class: "nav-item", -> a class: "nav-link", href: "https://mtasa.com", "get"
				li class: "nav-item", -> a class: "nav-link", href: "https://forum.mtasa.com", "forum"
				li class: "nav-item", -> a class: "nav-link", href: "https://wiki.mtasa.com", "wiki"
				li class: "nav-item", -> a class: "nav-link", href: "https://bugs.mtasa.com", "bugs"
				li class: "nav-item mta-separated-nav-item", -> a class: "nav-link", href: @url_for("resources.overview"), "resources"				

			ul class: "nav navbar-nav pull-xs-right", ->
				if @active_user
					li class: "nav-item", -> a class: "nav-link", href: @url_for("user.profile", username: @active_user.slug), @active_user.username
					if @active_user\can_open_admin_panel!
						li class: "nav-item", -> a class: "nav-link", href: @url_for("admin.dashboard"), "admin"
					li class: "nav-item", -> a class: "nav-link", href: @url_for("auth.logout"), i18n "layout.logout"
				else
					li class: "nav-item", -> a class: "nav-link", id: "login-btn", href: @url_for("auth.login"), i18n "auth.login_button"
					li class: "nav-item", -> a class: "nav-link", href: @url_for("auth.register"), i18n "auth.register_button"

				-- languages!
				li class: "nav-item form-inline btn-group", ->
					button type: "button", class: "btn btn-secondary btn-sm dropdown-toggle", id: "languagesDropdown", ["data-toggle"]: "dropdown", ["aria-haspopup"]: "true", ["aria-expanded"]: "false", ->
						raw "language (#{i18n.getLocale()}) "
						span class: "caret"
					
					div class: "dropdown-menu", ->
						a class: {"dropdown-item", active: i18n.getLocale() == "en"}, href: "?set_locale=en", "english (en)"
						a class: {"dropdown-item", active: i18n.getLocale() == "pi"}, href: "?set_locale=pi", "pirate (pi)"
			
			div class: "row", ->
				div class: "col-md-3 col-md-offset-9", ->					
					div class: "card card-toplogin pull-right", ->
						-- let's output the form for the login in here
						widget require "widgets.login_form"

	render_footer: => footer class: "row", ->
		div class: "col-md-8", ->
			p class: "tagline", -> em "[ stop playing with yourself ]"
			p -> raw "&copy; Qais Patankar 2015 - 2016"
			p -> raw "running lapis " .. require "lapis.version"

		div class: "col-md-2", ->
			ul ->
				li -> a href: "https://nightly.multitheftauto.com", "Nightlies"
				li -> a href: "https://github.com/multitheftauto", "GitHub"
				li -> a href: "https://wiki.multitheftauto.com", "Wiki"
				li -> a href: "https://bugs.multitheftauto.com", "Bug Tracker"
		
		div class: "col-md-2", ->
			ul ->
				li -> a href: "https://steamcommunity.com/groups/mta", ->
					i class: "fa fa-fw fa-steam-square"
					raw "Steam"
				li -> a href: "https://twitter.com/mtaqa", ->
					i class: "fa fa-fw fa-twitter-square"
					raw "Twitter"
				li -> a href: "https://www.facebook.com/multitheftauto/", ->
					i class: "fa fa-fw fa-facebook-square"
					raw "Facebook"
				li -> a href: "https://www.youtube.com/user/MTAQA", ->
					i class: "fa fa-fw fa-youtube-square"
					raw "YouTube"
