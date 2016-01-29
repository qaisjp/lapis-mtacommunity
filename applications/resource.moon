lapis = require "lapis"
db    = require "lapis.db"

import
	Resources
from require "models"
import
	error_404
	error_500
from require "utils"
import
	capture_errors
	assert_error
from require "lapis.application"

class ResourceApplication extends lapis.Application
	path: "/resources"
	name: "resources."

	@before_filter =>
		if @params.resource_name
			-- try to find the resource by slugname
			@resource = Resources\find [db.raw "lower(slug)"]: @params.resource_name\lower!

			-- no resource? 404 it.
			return @write error_404 @ unless @resource

	[overview: ""]: => render: true
	
	[view: "/:resource_name"]: capture_errors {
		on_error: error_500
		=>
			if @current_user
				-- this checks if the user is an admin OR given perms
				@is_user_special = @resource\is_user_special @current_user
			render: true
	}

	[edit: "/:resource_name/edit"]: capture_errors {
		on_error: error_500
		=>
			@write "You are now editing it."
	}