lapis = require "lapis"
db    = require "lapis.db"

import
	Resources
	ResourcePackages
	PackageDependencies
	Users
	Comments
from require "models"
import
	error_404
	error_405
	error_500
	assert_csrf_token
from require "utils"
import
	capture_errors
	assert_error
	yield_error
	respond_to
from require "lapis.application"
import
	from_json
	slugify
from require "lapis.util"
import decode_base64 from require "lapis.util.encoding"
import assert_valid from require "lapis.validate"
import var_dump from require "utils2"

lfs = require "lfs"

denest_table = (nested) ->
	tab = {}
	for obj in *nested
		table.insert tab, obj[1]
	tab

serve_file = (filepath, filename, mime, external) ->
	ngx.header.content_type = mime
	ngx.header.content_disposition = "attachment; filename=\"#{filename}\""

	unless external
		return ngx.exec "/"..filepath

	file, err = io.open filepath, "r"
	unless file
		return false, err
  
	contents = file\read "*all"
	file\close!

	result = os.remove filepath
	ngx.header.content_length = #contents
	ngx.say contents

	ngx.exit ngx.OK

build_filepath_upload_package = (resource, pkg, file) ->
	"uploads/#{resource}/#{pkg}.#{file}"

build_rename_comment = (oldname, newname) ->
	"@ #{oldname}\n@=#{newname}\n@ (comment above this line)\n"

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

	[test: "/uploads/*"]: =>
		ngx.exec "/uploads/#{@params.splat}"
	
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

	[comment: "/:resource_name/comment"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't make that comment for you."
		GET: error_405
		POST: =>
			assert_error @active_user, "You need to be logged in to do that."
			assert_valid @params, {
				{"message", exists: true}
			}
			Comments\create {
				resource: @resource.id,
				author: @active_user.id
				message: @params.message
			}
			redirect_to: @url_for "resources.view", resource_name: @resource.name
	}

	[get: "/:resource_name/get/:version"]: capture_errors {
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't serve you that file."
		=>
			-- We already know we're a resource, so first we need to
			-- check if our version is correct and exists.
			@package = assert_error (ResourcePackages\select "where (resource = ?) AND (version = ?) limit 1", @resource.id, @params.version, fields: "id, file, resource")[1]

			-- Are we asking ourselves for a download?
			if @params.download
				-- assert_csrf_token @

				local dependencies
				filepath = build_filepath_upload_package @package.resource, @package.id, @package.file
				filename = @resource.name .. ".zip"

				-- Lets try and decode a deps field...
				if jsonDeps = @params.deps
					dependencies = {}
					for _, jsonDep in pairs jsonDeps
						_, dep = assert_error pcall -> from_json decode_base64 jsonDep
						table.insert dependencies, dep

				-- Did we want any dependencies?
				if dependencies
					-- Get the exact packages we want to build
					query = {[[
						resource_packages.id, resources.name, file, resource
						FROM resource_packages, resources
						WHERE FALSE]]}

					for dep in *dependencies
						table.insert query, db.interpolate_query [[
							OR (
								(resources.name = ?)
								AND (resource_packages.version = ?)
								AND (resources.id = resource_packages.resource)
							)]], dep[1], dep[2]
					table.insert query, [[
						GROUP BY resources.name, resource_packages.id
					]]

					query = table.concat query, "\n"
					expectedLength = #dependencies
					_, dependencies = assert_error pcall -> db.select query

					unless #dependencies == expectedLength
						return error_500 @, "One of the resource dependencies you tried to download was unavailable."

					dir = lfs.currentdir!

					filepath = os.tmpname!
					os.remove filepath
					filepath..= ".zip"

					cmd = {
						"zip -0 -j"
						filepath,
						dir .. "/" .. build_filepath_upload_package @package.resource, @package.id, @package.file
					}

					renameComments = {build_rename_comment "#{@package.id}.#{@package.file}", filename}

					-- rename filename to "deps_with_..."
					filename = "deps_with_" .. filename

					for dep in *dependencies
						table.insert cmd, "\"#{dir}/#{build_filepath_upload_package dep.resource, dep.id, dep.file}\""
						table.insert renameComments, build_rename_comment "#{dep.id}.#{dep.file}", dep.name .. ".zip"
					
					cmd = table.concat cmd, " "
					renameCmd = "printf \"#{table.concat renameComments}\" | zipnote -w #{filepath}"

					print renameCmd	

					success = os.execute cmd
					unless success == 0
						os.remove filepath
						yield_error!
						return
					
					success = os.execute renameCmd
					unless success == 0
						os.remove filepath
						yield_error!
						return

				success, err = serve_file filepath, filename, "application/zip", dependencies and true
				unless success
					yield_error! -- ,err

			-- Okay, we already threw out the possibility of not having a package. Lets check for dependencies.
			dependencies = (db.select "get_package_dependencies(?) as deps ", @package.id)[1].deps
			unless #dependencies == 0
				-- Workaround for efficiently getting all package data in one query
				packagesNested = {}
				for dep in *dependencies
					table.insert packagesNested, {dep}
				-- actually get the package data
				ResourcePackages\include_in packagesNested, 1, as: 1

				-- Now we're reversing the workaround
				packages = denest_table packagesNested

				-- Get resource data
				Resources\include_in packages, "resource", as: "resource"
				@dependencies = packages

			render: true
	}