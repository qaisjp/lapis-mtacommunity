-- include using:
-- @include "widgets.utils"

class WidgetUtils
	output_errors: =>
		if @errors and #@errors > 0
			div class: "alert alert-danger", role: "alert", ->
				ul -> for err in *@errors do li err

	write_csrf_input: =>
		input type: "hidden", name: "csrf_token", value: @csrf_token, ["aria-hidden"]: "true"

	write_pagination_nav: (url, pages, current_page, post, get={}) =>
		old_get = get.page
		nav -> ul class: "pagination", ->
			get.page = current_page - 1

			-- This is the left arrow
			li class: "page-item", -> a class: "page-link", ["aria-label"]: "Previous", href: @url_for(url, post, get), ->
				span ["aria-hidden"]: "true", -> raw "&laquo;"
				span class: "sr-only", "Previous"

			for page = math.max(1, current_page-5), math.min(pages-1, current_page+4)
				active_class = "page-item " .. (if current_page == page then "active" else "")
				get.page = page
				li class: active_class, -> a class: "page-link", href: @url_for(url, post, get), page

			li class: "page-item disabled", -> span class: "page-link", "..."

			get.page = pages
			active_class = "page-item " .. (if current_page == pages then "active" else "")
			li class: active_class, -> a class: "page-link", href: @url_for(url, post, get), pages
			
			get.page = current_page + 1

			-- This is the right arrow
			li class: "page-item", -> a class: "page-link", ["aria-label"]: "Next", href: @url_for(url, post, get), ->
				span ["aria-hidden"]: "true", -> raw "&raquo;"
				span class: "sr-only", "Next"

		get.page = old_get