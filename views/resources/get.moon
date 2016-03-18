import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import var_dump from require "utils2"
import to_json from require "lapis.util"
import encode_base64 from require "lapis.util.encoding"
i18n = require "i18n"

class MTAResourcesGet extends Widget
	@include require "widgets.utils"
	content: =>
		h1 i18n "resources.get.h1", name: @resource.longname, version: @package.version

		unless @dependencies
			text i18n "resources.get.momentarily"
			raw " "
			form class: "form-inline mta-inline-form", id: "download-form", method: "post", action: "", ->
				@write_csrf_input!
				input type: "hidden", name: "download", value: "1", ["aria-hidden"]: "true"
				label ->
					text i18n "resources.get.please_click"
					raw " "
					button class: "btn btn-link mta-nopadding", type: "submit", i18n "resources.get.here"
					raw " "
					text i18n "resources.get.if_not_start"

			p -> strong i18n "resources.get.admin_warning"

			-- make the script automatically submit the download form
			@content_for "post_body_script", -> raw "<script>$('#download-form').submit();</script>"
			return


		p i18n "resources.get.dependency_note", name: @resource.name

		form method: "post", action: "", ->
			for i, dep in ipairs @dependencies
				div class: "checkbox", ->
					label ->
						name = dep.resource.name
						version = dep.version
						input type: "checkbox", name: "deps[#{i}]", value: encode_base64 to_json {name, version}
						text " #{name} - v#{version}"

			input class: "btn btn-primary", type: "submit", value: "download"
			@write_csrf_input!
			input type: "hidden", name: "download", value: "1", ["aria-hidden"]: "true"
