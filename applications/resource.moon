lapis = require "lapis"
db    = require "lapis.db"

import
	Resources
from require "models"
import error_404 from require "utils"
import
	capture_errors
	assert_error
from require "lapis.application"

class ResourceApplication extends lapis.Application
	path: "/resources"
	name: "resources."

	[overview: ""]: => render: true
	
	[view: "/:resource_name"]: capture_errors {
		on_error: =>
			@title = "Oops"
			@write "Something went wrong."

		=>
			-- try to find the resource by slugname
			@resource = Resources\find [db.raw "lower(slug)"]: @params.resource_name\lower!

			-- no resource? 404 it.
			return @write error_404 @ unless @resource
			render: true
	}