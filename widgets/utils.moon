class WidgetUtils
	write_csrf_input: =>
		input type: "hidden", name: "csrf_token", value: @csrf_token, ["aria-hidden"]: "true"

	write_pagination_nav: (url, pages, current_page, post, get={}) =>
		old_get = get.page
		nav -> ul class: "pagination", ->
			li class: "page-item", -> a class: "page-link", href: "#", ["aria-label"]: "Previous", -> span ["aria-hidden"]: "true", -> raw "&laquo;"
			for page = 1, pages
				active_class = "page-item" .. (if current_page == page then "active" else "")
				get.page = page
				li class: active_class, -> a class: "page-link", href: @url_for(url, post, get), page
			li class: "page-item", -> a class: "page-link", href: "#", ["aria-label"]: "Next", -> span ["aria-hidden"]: "true", -> raw "&laquo;"
		get.page = old_get