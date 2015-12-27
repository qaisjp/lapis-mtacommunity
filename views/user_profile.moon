import Widget from require "lapis.html"
import get_gravatar_url from require "utils"
class MTAUserProfile extends Widget
	content: =>
		div class: "page-header", ->
			div class: "media", ->
				div class: "media-left", -> img class: "media-object", src: get_gravatar_url @user.email, 150
				div class: "media-body", ->
					h1 class: "media-heading", "#{@user.username}"
					p ->
						i class: "fa fa-fw fa-clock-o"
						text "Joined on #{@user.created_at}"

					if loc = @data.location
						p ->
							i class: "fa fa-fw fa-map-marker"
							text loc

					if url = @data.website
						p ->
							i class: "fa fa-fw fa-link"
							a href: url, url

					if gang = @data.gang
						p ->
							i class: "fa fa-fw fa-users"
							text "Gang: #{gang}"

					if birthday = @data.birthday
						p ->
							i class: "fa fa-fw fa-birthday-cake"
							text: "Birthday: #{birthday}"

				div class: "media-right", ->
					if @active_user
						if (@active_user.id == @user.id) or (@active_user.level > @user.level)
							button type: "button", class: "btn btn-default", ->
								i class: "fa fa-fw fa-pencil"
								text "Edit profile"