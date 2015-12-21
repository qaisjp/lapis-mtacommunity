import Widget from require "lapis.html"

class Layout extends Widget
	content: => html_5 ->
		head ->
			meta charset: "utf-8"
			meta ["http-equiv"]: "X-UA-Compatible", content: "IE=edge"
			meta name: "viewport", content: "width=device-width, initial-scale=1"
			-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags 

			meta name: "description", content: "The Multi Theft Auto Community Website"
			link rel: "icon", href: "favicon.ico"
			title @title and (@title .. " - Multi Theft Auto Community") or "Multi Theft Auto Community"

			-- Font Awesome icons
			link href: "/bower_components/font-awesome/css/font-awesome.css", rel: "stylesheet"
			
			-- Bootstrap core CSS
			link href: "/bower_components/bootstrap/dist/css/bootstrap.css", rel: "stylesheet"

			-- Bootstrap theme CSS
			link href: "/bower_components/bootstrap/dist/css/bootstrap-theme.css", rel: "stylesheet"

			-- Custom styles
			link href: "/static/css/main.css", rel: "stylesheet"

			-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries
			raw "<!--[if lt IE 9]>"
			script src: "https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"
			script src: "https://oss.maxcdn.com/respond/1.4.2/respond.min.js"
			raw "<![endif]-->"

		body ->
			nav class: "navbar navbar-inverse navbar-fixed-top", -> div class: "container", ->
				div class: "navbar-header", ->
					button type: "button", class: "navbar-toggle collapsed", ["data-toggle"]: "collapse", ["data-target"]: "#navbar", ["aria-expanded"]: "false", ["aria-controls"]: "navbar", ->
						span class: "sr-only", "Toggle navigation"
						span class: "icon-bar"
						span class: "icon-bar"
						span class: "icon-bar"
					a class: "navbar-brand", href: "/", "mta community"

				div id:"navbar", class: "navbar-collapse collapse", ->
					ul class: "nav navbar-nav mta-navbar-links", ->
						li -> a href: "https://mtasa.com", "home"
						li -> a href: "https://forum.mtasa.com", "forum"
						li -> a href: "https://wiki.mtasa.com", "wiki"
						li -> a href: "https://bugs.mtasa.com", "bugs"
						li -> a href: "/resources", "resources"
					
					div class: "navbar-right navbar-form navbar-text btn-group", ->
						button type: "button", class: "btn btn-default btn-xs dropdown-toggle", ["data-toggle"]: "dropdown", ["aria-haspopup"]: "true", ["aria-expanded"]: "false", ->
							raw "en-gb "
							span class: "caret"
						
						ul class: "dropdown-menu", ->
							li -> a "languages"
							li role: "separator", class: "divider"
							li class: "active", -> a href: "#", "english (en-gb)"
							li -> a href: "#", "pirate (en-arr)"
							li -> a href: "#", "pig latin (en-pl)"
		
					ul class: "nav navbar-nav navbar-right", ->
						li -> a id: "login-btn", "login"
						li -> a id: "register-btn", href: "#", "register"
				
				div class: "row", ->
					div class: "col-md-3 col-md-offset-9", ->
						div class: "panel panel-default panel-toplogin pull-right", -> form ->
							div class: "input-group", ->
								span class: "input-group-addon", -> i class: "fa fa-fw fa-user"
								input type: "text", class: "form-control", placeholder: "username", autocomplete: "on", name: "username"

							div class: "input-group", ->
								span class: "input-group-addon", -> i class: "fa fa-fw fa-key"
								input type: "password", class: "form-control", placeholder: "password", autocomplete: "on", name: "password"
							
							row class: "no-gutter", ->
								div class: "col-md-4", ->
									button type: "button", class: "btn btn-default", -> i class: "fa fa-fw fa-question"
								
								div class: "col-md-8", ->
									div class: "input-group", ->
										span class: "input-group-addon", -> input type: "checkbox", name: "remember"
										button type: "submit", class: "form-control btn btn-default", "login"
		
			div class: "container", ->					
				@content_for "inner"

				hr!

				footer class: "row", ->
					div class: "col-md-8", ->
						p class: "tagline", -> em "[ stop playing with yourself ]"
						p -> raw "&copy; Qais Patankar 2015"
					
					div class: "col-md-2", ->
						ul ->
							li -> a href: "#", "Nightlies"
							li -> a href: "#", "GitHub"
							li -> a href: "#", "Wiki"
							li -> a href: "#", "Mantis"
					
					div class: "col-md-2", ->
						ul ->
							li -> a href: "#", ->
								i class: "fa fa-fw fa-steam-square"
								raw "Steam"
							li -> a href: "#", ->
								i class: "fa fa-fw fa-twitter-square"
								raw "Twitter"
							li -> a href: "#", ->
								i class: "fa fa-fw fa-facebook-square"
								raw "Facebook"
							li -> a href: "#", ->
								i class: "fa fa-fw fa-youtube-square"
								raw "YouTube"
			-- /container


			-- Bootstrap core JavaScript
			-- Placed at the end of the document so the pages load faster
			script src: "/bower_components/jquery/dist/jquery.js"
			script src: "/bower_components/bootstrap/dist/js/bootstrap.js"

			
			-- IE10 viewport hack for Surface/desktop Windows 8 bug
			script src: "/static/js/ie10-viewport-bug-workaround.js"

			-- Now finally, our own code!
			script src: "/static/js/main.js"
		-- /body
	--/html

		
			-- @content_for "inner"