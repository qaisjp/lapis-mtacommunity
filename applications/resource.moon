lapis = require "lapis"
db    = require "lapis.db"

import
	Resources
	ResourcePackages
	Users
from require "models"
import
	error_404
	error_500
from require "utils"
import
	capture_errors
	assert_error
	yield_error
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
			-- Get all the authors of the resource
			@authors = @resource\get_authors "users.username, users.id"
			
			-- If we're logged in...			
			if @active_user
				-- ... are we an author?
				for author in *@authors do
					if author.id == @active_user.id then
						@active_user_is_author = true
						break

			-- Paginator for comments
			@commentsPaginator = @resource\get_comments_paginated {
				per_page: 65536 -- postpone pagination code
				prepare_results: (comments) ->
					-- Allows comment authors to be loaded in one query
					-- (this is much much faster than a query in a loop)
					Users\include_in comments, "author", as: "author"
			}

			-- Paginator for packages
			@packagesPaginator = @resource\get_packages_paginated {
				per_page: 65536 -- postpone pagination code
			}

			render: true
	}

	[edit: "/:resource_name/edit"]: capture_errors {
		on_error: error_500
		=>
			@write "You are now editing it."
	}

	[get: "/:resource_name/get/:version"]: capture_errors {
		on_error: => error_500 @, "We're sorry we couldn't serve you that file."
		=>
			-- We already know we're a resource, so first we need to
			-- check if our version is correct and exists.
			packages = ResourcePackages\select "where (resource = ?) AND (version = ?) limit 1", @resource.id, @params.version, fields: "id, file"
			@write "length #{#packages}"
	}