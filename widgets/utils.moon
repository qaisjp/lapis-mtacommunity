class WidgetUtils
	write_csrf_input: =>
		input type: "hidden", name: "csrf_token", value: @csrf_token, ["aria-hidden"]: "true"

	write_pagination_nav: (url, pages, current_page) =>
		nav -> ul class: "pagination", ->
			li -> a href: "#", ["aria-label"]: "Previous", -> span ["aria-hidden"]: "true", -> raw "&laquo;"
			for page = 1, pages
				active_class = if current_page == page then "active" else ""
				li class: active_class, -> a href: @url_for(url, nil, page: page), page
			li -> a href: "#", ["aria-label"]: "Next", -> span ["aria-hidden"]: "true", -> raw "&laquo;"