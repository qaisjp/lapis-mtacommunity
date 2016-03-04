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
	serve_file
	check_logged_in
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

lfs = require "lfs"

-- general function to build a path relative to the web root
build_filepath_upload_package = (resource, pkg, file) ->
	"uploads/#{resource}/#{pkg}.#{file}"

-- generate statements for renaming in zipnote comments
build_rename_comment = (oldname, newname) ->
	"@ #{oldname}\n@=#{newname}\n@ (comment above this line)\n"

check_file = (file) ->
	-- open up a feed
	output, err = io.popen "../mtacommunity-cli/mtacommunity-cli check --file=#{file}"

	-- if it failed to open...
	return false, {"Internal error..."} unless output

	-- read all the possible errors...
	errors = {}
	success = true	
	for line in output\lines! do
		-- did we have a reportable error?
		if line\sub(1, 7) == "error: "
			success = false
			table.insert errors, line\sub 8

		-- are we done? is everything okay?
		elseif line == "ok"
			success = true
			break

		-- we got something else...
		else
			success = false
			errors  = {"Internal error..."}
	
	output\close!
	return success, errors

class ResourceApplication extends lapis.Application
	path: "/resources"
	name: "resources."

	@before_filter =>
		-- are we on a route for specific resources?
		if @params.resource_slug
			-- try to find the resource by slugname
			@resource = Resources\find [db.raw "lower(slug)"]: @params.resource_slug\lower!

			-- no resource? 404 it.
			return @write error_404 unless @resource

	[overview: ""]: => render: true

	-- TODO
	[upload: "/upload"]: capture_errors respond_to {
		before: => check_logged_in @
		GET: => render: true
		POST: =>
			assert_valid @params, {
				{"resUpload", is_file: true, exists: true}
				{"resName", exists: true }
				{"resDescription", exists: true }
			}

			filename = os.tmpname!			
			file = io.open(filename, "w")
			file\write @params.resUpload.content
			file\close!

			success, @errors = check_file filename
			os.remove filename

			return render: true if not success

			@errors = {"success!!"}
			render: true
	}
	
	[view: "/:resource_slug"]: capture_errors {
		on_error: error_500
		=>
			-- Get all the authors of the resource
			@authors = @resource\get_authors "users.username, users.slug, users.id"
			
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

	-- TODO
	[manage: "/:resource_slug/manage"]: capture_errors {
		on_error: error_500
		=>
			"You are now editing " .. @resource.name
			
	}

	[comment: "/:resource_slug/comment"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't make that comment for you."
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_error @active_user, "You need to be logged in to do that."
			assert_valid @params, {
				{"message", exists: true}
			}
			Comments\create {
				resource: @resource.id,
				author: @active_user.id
				message: @params.message
			}
			redirect_to: @url_for "resources.view", resource_slug: @resource.name
	}

	[get: "/:resource_slug/get(/:version)"]: capture_errors {
		on_error: => error_500 @, @errors[1] or "We're sorry we couldn't serve you that file."
		=>
			-- We already know we're a resource
			fields = "id, file, resource, download_count, version"
			if @params.version
				-- check if our version is correct and exists.
				@package = assert_error (ResourcePackages\select "where (resource = ?) AND (version = ?) limit 1", @resource.id, @params.version, :fields)[1]
			else
				-- get the last created resource
				@package = assert_error (ResourcePackages\select "where (resource = ?) order by created_at desc limit 1", @resource.id, :fields)[1]

			-- Are we asking ourselves for a download?
			if @params.download
				assert_csrf_token @

				-- build the base package path as well as its filename
				filepath = build_filepath_upload_package @package.resource, @package.id, @package.file
				filename = @resource.name .. ".zip"

				-- Lets try and decode a deps field...
				local dependencies -- shadow the variable
				if jsonDeps = @params.deps
					dependencies = {}
					for _, jsonDep in pairs jsonDeps
						-- safely decode the base64 dependency info to get json
						-- and in the same function, convert the json to a table
						_, dep = assert_error pcall -> from_json decode_base64 jsonDep

						table.insert dependencies, dep

				-- Did we want any dependencies?
				if dependencies
					-- Get the exact packages we want to build
					query = {[[
						resource_packages.id, resources.name, file, resource
						FROM resource_packages, resources
						WHERE FALSE]]}

					-- Add a clause checking for each dependency
					for dep in *dependencies
						table.insert query, db.interpolate_query [[
							OR (
								(resources.name = ?)
								AND (resource_packages.version = ?)
								AND (resources.id = resource_packages.resource)
							)]], dep[1], dep[2]

					-- prevent duplicates
					table.insert query, [[
						GROUP BY resources.name, resource_packages.id
					]]

					query = table.concat query, "\n"
					expectedLength = #dependencies
					_, dependencies = assert_error pcall -> db.select query

					unless #dependencies == expectedLength
						return error_500 @, "One of the resource dependencies you tried to download was unavailable."

					dir = lfs.currentdir!

					filepath = os.tmpname! -- get a temporary file
					os.remove filepath -- delete the lua created one
					filepath..= ".zip" -- append .zip to the temp filename

					-- base command for creating the zip file
					cmd = {
						"zip -0 -j"
						filepath,
						dir .. "/" .. build_filepath_upload_package @package.resource, @package.id, @package.file
					}

					-- add a renamer to the base package
					renameComments = {build_rename_comment "#{@package.id}.#{@package.file}", filename}

					-- rename filename to "deps_with_..."
					filename = "deps_with_" .. filename

					for dep in *dependencies
						-- add the package to the zip file
						table.insert cmd, "\"#{dir}/#{build_filepath_upload_package dep.resource, dep.id, dep.file}\""

						-- rename the package to something friendly
						table.insert renameComments, build_rename_comment "#{dep.id}.#{dep.file}", dep.name .. ".zip"
					
					cmd = table.concat cmd, " "
					renameCmd = "printf \"#{table.concat renameComments}\" | zipnote -w #{filepath}"

					-- build the zip file
					success = os.execute cmd
					unless success == 0
						os.remove filepath
						yield_error!
						return
					
					-- rename each file in the zip file
					success = os.execute renameCmd
					unless success == 0
						os.remove filepath
						yield_error!
						return

				@package.download_count += 1
				@resource.downloads += 1
				@package\update "download_count"
				@resource\update "downloads"

				-- throw it to the user!
				success, err = serve_file filepath, filename, "application/zip", dependencies and true
				unless success
					yield_error! -- ,err

			-- Okay, we already threw out the possibility of not having a package. Lets check for dependencies.
			dependencies = (db.select "get_package_dependencies(?) as deps ", @package.id)[1].deps
			unless #dependencies == 0
				packages = ResourcePackages\find_all dependencies

				-- Get resource data
				Resources\include_in packages, "resource", as: "resource"
				@dependencies = packages

			render: true
	}