lapis = require "lapis"
db    = require "lapis.db"
date  = require "date"
lfs   = require "lfs"
i18n  = require "i18n"
import
	Comments
	PackageDependencies
	Resources
	ResourcePackages
	ResourceRatings
	ResourceReports
	ResourceScreenshots
	Users
from require "models"
import
	error_404
	error_405
	error_500
	error_not_authorized
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
import
	check_resource_file
	build_package_filepath
	build_screenshot_filepath
	build_rename_comment
from require "helpers.uploads"
lfs = require "lfs"

class ResourceApplication extends lapis.Application
	path: "/resources"
	name: "resources."

	@before_filter =>
		-- are we on a route for specific resources?
		if @params.resource_slug
			-- try to find the resource by slugname
			@resource = Resources\find [db.raw "lower(slug)"]: @params.resource_slug\lower!
			
			-- no resource? 404 it.
			return @write error_404 @ unless @resource


	@include "applications.manage_resource"

	[overview: ""]: => render: true

	[upload: "/upload"]: capture_errors respond_to {
		before: => check_logged_in @
		GET: => render: true
		POST: =>
			assert_valid @params, {
				{"resUpload", is_file: true, exists: true}
				{"resName", exists: true, max_length: 255}
				{"resDescription", exists: true }
			}

			assert_error ResourcePackages\check_file_size @params.resUpload

			-- check if the resource already exists
			name, slug = Resources\is_name_available @params.resName
			yield_error slug unless name

			resource = 
				:name 
				:slug
				description: @params.resDescription
				creator: @active_user.id

			filename = os.tmpname!			
			file = io.open filename, "w"
			file\write @params.resUpload.content
			file\close!

			metaResults, @errors = check_resource_file filename
			
			if not metaResults
				os.remove filename
				return render: true
			
			resource.type = Resources.types\for_db metaResults.type
			resource.longname = metaResults.name

			resource = assert_error Resources\create resource
			
			package =
				version: metaResults.version
				description: "First release"
				uploader: @active_user.id
				resource: resource.id
				file: date!\spanseconds!

			clean_assert = (success, err, ...) ->
				return success, err, ... if success
				resource\delete!
				yield_error err

			package = clean_assert ResourcePackages\create(package), i18n "resources.manage.errors.not_create_package"

			-- create folders...
			clean_assert lfs.mkdir "uploads/#{resource.id}"
			clean_assert lfs.mkdir "uploads/#{resource.id}/packages"
			clean_assert lfs.mkdir "uploads/#{resource.id}/screenshots"

			_, file = clean_assert pcall io.open, build_package_filepath(resource.id, package.id, package.file), "w"

			file\write @params.resUpload.content
			file\close!

			redirect_to: @url_for "resources.view", resource_slug: resource.slug
	}
	
	[view: "/:resource_slug"]: capture_errors {
		on_error: => error_500 @, @errors[1]
		=>
			-- Get all the authors of the resource
			@authors = @resource\get_authors fields: "users.username, users.slug, users.id", is_confirmed: true, include_creator: true
			
			-- If we're logged in...			
			if @active_user
				-- get the user rights
				@rights = @resource\get_rights @active_user, nil

			-- Paginator for comments
			@commentsPaginator = @resource\get_comments_paginated {
				per_page: 65536 -- no pagination (yet)
				prepare_results: (comments) ->
					-- Allows comment authors to be loaded in one query
					-- (this is much much faster than a query in a loop)
					Users\include_in comments, "author", as: "author"
			}

			-- Paginator for packages
			@packagesPaginator = @resource\get_packages_paginated {
				per_page: 65536 -- no pagination (yet)
			}

			@screenshotsPaginator = @resource\get_screenshots_paginated per_page: 66536

			render: "resources.layout"
	}

	[delete_comment: "/:resource_slug/delete_comment/:comment[%d]"]: capture_errors respond_to {
		before: => check_logged_in
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{"comment", exists: true, is_integer: true}
			}

			comment = Comments\find id: @params.comment
			yield_error i18n "resources.manage.errors.comment_not_exist" unless comment

			if comment.author != @active_user.id
				@rights = (@resource\get_rights @active_user, nil) or {}
				return error_not_authorized @ if not (@rights.can_moderate or @active_user\can_open_admin_panel!)

			assert_error comment\delete!
			redirect_to: @url_for @resource
	}

	[view_screenshot: "/:resource_slug/screenshots/:screenie_id[%d]"]: capture_errors {
		on_error: => error_500 @, @errors[1]
		=>
			-- Get all the authors of the resource
			@screenshot = ResourceScreenshots\find resource: @resource.id, id: @params.screenie_id
			@screenshot.resource = @resource
			yield_error i18n "resources.manage.errors.no_screenshot" unless @screenshot

			render: "resources.layout"
	}

	[view_screenshot_image: "/:resource_slug/screenshots/:screenie_id[%d].png"]: capture_errors {
		on_error: => error_500 @, @errors[1]
		=>
			-- Get all the authors of the resource
			screenshot = ResourceScreenshots\find resource: @resource.id, id: @params.screenie_id
			yield_error i18n "resources.manage.errors.no_screenshot" unless screenshot

			filename = screenshot.title and ("#{slugify screenshot.title}.png") or ("#{slugify resource.name}_screenshot.png")

			opts = {
				filepath: build_screenshot_filepath(@resource.id, screenshot.id, screenshot.file)
				:filename
				external: false -- defaults to this anyway
				-- todo: add correct mime type
			}

			assert_error serve_file opts

			yield_error i18n "resources.manage.errors.image_not_served"
	}

	[report_resource: "/:resource_slug/report"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_error @active_user, i18n "auth.need_logged_in"
			assert_csrf_token @

			pcall -> ResourceReports\create resource: @resource.id, reporter: @active_user.id
			redirect_to: @url_for "resources.overview"

	}

	[post_comment: "/:resource_slug/comment"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1] or i18n "resources.comment.errors.friendly_create"
		GET: error_405
		POST: =>
			assert_error @active_user, i18n "auth.need_logged_in"
			assert_csrf_token @
			assert_valid @params, {
				{"comment_text", exists: true}
			}

			parent = tonumber @params.comment_parent
			if parent
				parentObj = Comments\find parent
				if (not parentObj)
					yield_error i18n "resources.comment.errors.parent_missing"
				else if parentObj.parent
					-- tell them we can't find a parent comment if the comment
					-- they tried to reply to is a child comment
					yield_error i18n "resources.comment.errors.cannot_reply_to_reply"


			Comments\create {
				resource: @resource.id,
				author: @active_user.id
				message: @params.comment_text
				:parent
			}
			redirect_to: @url_for "resources.view", resource_slug: @resource.slug
	}

	[cast_vote: "/:resource_slug/cast_vote"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1] or i18n "resources.errors.friendly_cast_vote"
		GET: error_405
		POST: =>
			assert_csrf_token @				
			assert_error @active_user, i18n "auth.need_logged_in"
			assert_valid @params, {
				{"vote", one_of: {"up", "down", "none"}}
			}
			local increment

			existingRating = ResourceRatings\find resource: @resource.id, user: @active_user.id
			if (@params.vote == "none") and existingRating
				increment = -(existingRating.rating and 1 or -1)
				assert_error existingRating\delete!
			elseif @params.vote != "none"
				isUpvoting = @params.vote == "up"
				increment = isUpvoting and 1 or -1

				
				if existingRating
					increment -= existingRating.rating and 1 or -1
					existingRating\update rating: isUpvoting
				else
					ResourceRatings\create resource: @resource.id, user: @active_user.id, rating: isUpvoting

			if increment
				@resource\update rating: @resource.rating + increment
			redirect_to: @url_for "resources.view", resource_slug: @resource.slug
	}

	[get: "/:resource_slug/get(/:version)"]: capture_errors {
		on_error: => error_500 @, @errors[1] or i18n "resources.errors.friendly_serve_file"
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
				filepath = build_package_filepath @package.resource, @package.id, @package.file
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
						return error_500 @, i18n "resources.errors.dependencies_unavailable"

					dir = lfs.currentdir!

					filepath = os.tmpname! -- get a temporary file
					os.remove filepath -- delete the lua created one
					filepath..= ".zip" -- append .zip to the temp filename

					-- base command for creating the zip file
					cmd = {
						"zip -0 -j"
						filepath,
						dir .. "/" .. build_package_filepath @package.resource, @package.id, @package.file
					}

					-- add a renamer to the base package
					renameComments = {build_rename_comment "#{@package.id}.#{@package.file}", filename}

					-- rename filename to "deps_with_..."
					filename = "deps_with_" .. filename

					for dep in *dependencies
						-- add the package to the zip file
						table.insert cmd, "\"#{dir}/#{build_package_filepath dep.resource, dep.id, dep.file}\""

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
				success, err = serve_file {
					:filepath
					:filename
					external: dependencies and true
					header: {
						-- set the correct mime type, so the browser doesn't display
						-- knows how to deal with this type of file
						content_type: "application/zip"

						-- make the browser download the file instead of showing it inline
						-- as well as set the filename for the "attachment"
						content_disposition: "attachment; filename=\"#{filename}\""
					}
				}

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
