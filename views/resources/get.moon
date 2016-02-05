import Widget from require "lapis.html"
import Resources, ResourcePackages from require "models"
import var_dump from require "utils2"
import to_json from require "lapis.util"
import encode_base64 from require "lapis.util.encoding"

class MTAResourcesGet extends Widget
	@include require "widgets.utils"
	content: =>
		h1 "Downloading #{@resource.name} v#{@params.version}"

		unless @dependencies
			p "Your download should start momentarily."
			p -> strong "Do not give administrator rights to any resource unless you trust it."
			return

		p "This resource depends on other resources. Please select the resources you would like in your download - you should not need to check resources that you already have."

		form method: "post", action: "", ->
			for i, dep in ipairs @dependencies
				div class: "checkbox", ->
					label ->
						name = dep.resource.name
						version = dep.version
						input type: "checkbox", name: "deps[#{i}]", value: encode_base64 to_json {name, version}
						text " #{name} - v#{version}"

			input class: "btn btn-primary", type: "submit", value: "submit"
			@write_csrf_input!
			input type: "hidden", name: "download", value: "1", ["aria-hidden"]: "true"