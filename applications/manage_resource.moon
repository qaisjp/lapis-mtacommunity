lapis = require "lapis"
db    = require "lapis.db"
date  = require "date"
i18n  = require "i18n"
import
	Comments
	Resources
	ResourcePackages
	ResourceScreenshots
	ResourceAdmins
	PackageDependencies
	Users
from require "models"
import
	error_404
	error_405
	error_500
	error_not_authorized
	error_bad_request
	assert_csrf_token
	check_logged_in
from require "utils"
import
	capture_errors
	assert_error
	yield_error
	respond_to
from require "lapis.application"
import assert_valid from require "lapis.validate"
import build_screenshot_filepath, build_package_filepath, check_resource_file from require "helpers.uploads"

class ManageResourceApplication extends lapis.Application
	path: "/:resource_slug/manage"
	name: "manage."

	@before_filter =>
		if not check_logged_in @
			return

		-- get the user rights
		@rights = @resource\get_rights @active_user, nil
		
		unless @rights
			return @write error_not_authorized @

		if (@route_name != "resources.manage.invite_reply") and (not @rights.user_confirmed)
			return @write error_not_authorized @, i18n "resources.manage.errors.invite_accept_first"

		@right_names = {"can_configure", "can_moderate", "can_manage_authors", "can_manage_packages", "can_upload_screenshots"}

		-- see views.resources.manage.layout to add sections
		@tab_names = {"Dashboard", "Details", "Packages", "Authors", "Settings", "Screenshots"}
		@tabs = {
			dashboard: true,
			details: @rights.can_configure
			packages: @rights.can_manage_packages
			settings: @resource.creator == @active_user.id
			authors: @rights.can_manage_authors
			screenshots: @rights.can_upload_screenshots
		}

		@check_tab = (tab) =>
			assert tab
			unless @tabs[tab]
				return @write error_not_authorized @


	["":""]: => redirect_to: @url_for "resources.manage.dashboard", resource_slug: @resource
	
	[dashboard: "/dashboard"]: capture_errors respond_to {
		before: => @check_tab "dashboard"
		on_error: => error_500 @, @errors[1]
		GET: => render: "resources.manage.layout"
	}

	[details: "/details"]: capture_errors respond_to {
		before: => @check_tab "details"
		on_error: => error_500 @, @errors[1]
		GET: => render: "resources.manage.layout"
	}

	[packages: "/packages"]: capture_errors respond_to {
		before: => @check_tab "packages"
		on_error: => render: "resources.manage.layout" --error_500 @, @errors[1]
		POST: =>
			assert_valid @params, {
				{"uploadFile", is_file: true, exists: true}
				{"uploadChangelog", exists: true }
			}

			assert_error ResourcePackages\check_file_size @params.uploadFile
			
			filename = os.tmpname!			
			file = io.open filename, "w"
			file\write @params.uploadFile.content
			file\close!

			metaResults, @errors = check_resource_file filename
			if not metaResults
				os.remove filename
				return render: "resources.manage.layout"

			if ResourcePackages\find version: metaResults.version, resource: @resource.id
				yield_error i18n "resources.manage.errors.version_exists"

			package =
				version: metaResults.version
				description: @params.uploadChangelog
				uploader: @active_user.id
				resource: @resource.id
				file: date!\spanseconds!

			package = assert_error ResourcePackages\create(package), i18n "resources.manage.not_create_package"
			
			-- update all package deps that are on the old resource version
			db.query [[UPDATE package_dependencies
				SET package = ?
				FROM resources, resource_packages
				WHERE
				resources.id = ?
				AND resources.id = resource_packages.resource
				AND resource_packages.id = package_dependencies.package
				AND needs_version = false]], package.id, @resource.id

			_, file = assert_error pcall io.open, build_package_filepath(@resource.id, package.id, package.file), "w"

			file\write @params.uploadFile.content
			file\close!

			@resource\update longname: metaResults.name, type: Resources.types\for_db metaResults.type

			render: "resources.manage.layout"
		GET: => render: "resources.manage.layout"
	}

	[view_package: "/packages/:pkg_id[%d]"]: capture_errors respond_to {
		before: =>
			@check_tab "packages"
			@package = assert_error (ResourcePackages\find resource: @resource.id, id: @params.pkg_id), i18n "resources.manage.errors.no_package"

		on_error: => error_500 @, @errors[1]
		POST: =>
			assert_csrf_token @

			if @params.updateDescription
				@package\update description: @params.updateDescription
			elseif @params.addInclude == "true"
				assert_valid @params, {
					{"include_resource", exists: true}
				}
				if @params.include_version == ""
					@params.include_version = nil

				target_resource = assert_error Resources\search(@params.include_resource), i18n "resources.manage.errors.invalid_name"

				local package
				if ver = @params.include_version
					package = ResourcePackages\find resource: target_resource.id, version: ver
					assert_error package, i18n "resources.manage.errors.version_search_fail"
				else
					package = (ResourcePackages\select "where resource = ? order by created_at desc limit 1", target_resource.id)[1]


				assert_error package, i18n "errors.internal_error"
				
				already_exists = nil != PackageDependencies\find source_package: @package.id, package: package.id
				yield_error i18n "resources.manage.errors.package_already_dep" if already_exists

				PackageDependencies\create source_package: @package.id, package: package.id, needs_version: (@params.include_version != nil)

			render: "resources.manage.layout"
		GET: =>	render: "resources.manage.layout"
	}

	[screenshots: "/screenshots"]: capture_errors respond_to {
		before: => @check_tab "screenshots"
		on_error: => error_500 @, @errors[1]
		GET: => render: "resources.manage.layout"
		POST: =>
			assert_valid @params, {
				{"screenieFile", is_file: true, exists: true}
				{"screenieTitle", exists: true }
			}

			do
				title = @params.screenieFile.filename\lower!
				endsWith = (ext) -> title\sub(-#ext) == ext\lower!
				unless endsWith("jpg") or endsWith("png") or endsWith("jpeg") or endsWith("gif")
					yield_error i18n "resources.manage.errors.invalid_file_type"

			filesize = #@params.screenieFile.content 
			yield_error i18n "errors.max_filesize", max: "2Mb", ours: filesize if filesize > 2 * 1000 * 1000

			screenshot = 
				resource: @resource.id
				title: @params.screenieTitle
				description: @params.screenieDescription
				uploader: @active_user.id
				file: date!\spanseconds!
			
			screenshot = assert_error ResourceScreenshots\create(screenshot), i18n "resources.manage.errors.not_create_screenshot"

			clean_assert = (success, err, ...) ->
				return success, err, ... if success
				screenshot\delete!
				yield_error err

			filename = build_screenshot_filepath @resource.id, screenshot.id, screenshot.file
			_, file, err  = clean_assert pcall io.open, filename, "w"
			assert_error file, err

			file\write @params.screenieFile.content
			file\close!

			redirect_to: @url_for "resources.view", resource_slug: @resource.slug
	}

	[view_screenshot: "/screenshots/:screenie_id[%d]"]: capture_errors respond_to {
		before: =>
			@check_tab "screenshots"
			@screenshot = assert_error (ResourceScreenshots\find resource: @resource.id, id: @params.screenie_id), i18n "resources.manage.errors.no_screenshot"

		on_error: => error_500 @, @errors[1]
		POST: =>
			assert_csrf_token @

			if @params.deleteScreenie
				assert_error @screenshot\delete!
				return redirect_to: @url_for("resources.manage.screenshots", resource_slug: @resource)
		
			assert_valid @params, {
				{"screenieTitle", exists: true}
			}

			@screenshot\update
				title: @params.screenieTitle
				description: @params.screenieDescription or ""

			render: "resources.manage.layout"
		GET: =>	render: "resources.manage.layout"
	}

	[settings: "/settings"]: capture_errors respond_to {
		before: => @check_tab "settings"
		on_error: => error_500 @, @errors[1]
		GET: => render: "resources.manage.layout"
	}

	[authors: "/authors(/:author)"]: capture_errors respond_to {
		before: => @check_tab "authors"
		on_error: => error_500 @, @errors[1]
		GET: =>
			if author_slug = @params.author
				while true do
					@author = Users\find slug: author_slug
					unless @author
						@errors = {i18n "resources.manage.errors.not_find_author", name: author_slug}
						break -- continue to render

					@author_rights = @resource\get_rights @author, nil
					if (not @author_rights) or (@author.id == @resource.creator)
						@author_rights = nil
						@author = nil
						@errors = {i18n "resources.manage.errors.not_existing_author", name: author_slug}
						break

					break -- always continue to render, don't iterate.

			render: "resources.manage.layout"
	}

	[update_description: "/update_description"]: capture_errors respond_to {
		before: => @check_tab "details"
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_valid @params, {{"resDescription", exists: true}}
			@resource\update description: @params.resDescription

			-- refresh
			redirect_to: @url_for "resources.manage.details", resource_slug: @resource
	}

	[transfer_ownership: "/transfer_ownership"]: capture_errors respond_to {
		before: => @check_tab "settings"
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{"settingsNewOwner", exists: true, min_length: 1, max_length: 255}
			}

			-- check if new owner exists
			new_owner = Users\search @params.settingsNewOwner

			-- future: 
				-- send email to existing owner
				-- link in email will send request to new owner
				-- newOwner accepts request to become owner

			-- make new owner the owner
			@resource\update creator: new_owner.id	

			-- redirect to main resource page (we no longer have permissions)
			redirect_to: @url_for @resource
	}

	[rename: "/rename"]: capture_errors respond_to {
		before: => @check_tab "settings"
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{"settingsNewResourceName", exists: true, min_length: 1, max_length: 255}
			}
			assert_error @resource\rename @params.settingsNewResourceName
			redirect_to: @url_for "resources.manage.settings", resource_slug: @resource
	}

	[delete: "/delete"]: capture_errors respond_to {
		before: => @check_tab "settings"
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_error @resource\delete!
			redirect_to: @url_for "resources.overview"
	}

	[delete_author: "/delete_author"]: capture_errors respond_to {
		before: => @check_tab "authors"
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{ "author", exists: true }
			}

			result = db.query [[
				DELETE FROM resource_admins USING users
				WHERE
				(
					(resource_admins.resource = ?) AND
					(resource_admins.user = users.id) AND
					(users.slug = ?)
				)
			]], @resource.id, @params.author

			yield_error "Failed to remove #{@params.author}" if result.affected_rows == 0
			print "Multiple deletes?!" if result.affected_rows > 1

			-- refresh
			redirect_to: @url_for "resources.manage.authors", resource_slug: @resource
	}

	[update_author_rights: "/update_author_rights"]: capture_errors respond_to {
		before: => @check_tab "authors"
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{ "author", exists: true }
			}

			author = Users\find slug: @params.author
			yield_error i18n "resources.manage.errors.not_find_author", name: @params.author unless author

			rightsObj = ResourceAdmins\find resource: @resource.id, user: author.id
			if (not rightsObj) or (author.id == @resource.creator)
				yield_error i18n "resources.manage.errors.not_existing_author", name: author_slug

			for right in *@right_names
				rightsObj[right] = (@params[right] == "true")

			rightsObj\update unpack @right_names

			redirect_to: @url_for "resources.manage.authors", resource_slug: @resource, author: author.slug
	}

	[invite_author: "/invite_author"]: capture_errors respond_to {
		before: => @check_tab "authors"
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			assert_csrf_token @
			assert_valid @params, {
				{ "author", exists: true }
			}

			author = Users\search @params.author
			yield_error i18n "resources.manage.errors.not_find_author", name: @params.author unless author

			if @resource\is_user_admin author
				yield_error i18n "resources.manage.errors.already_author", name: author.slug

			ResourceAdmins\create resource: @resource.id, user: author.id

			redirect_to: @url_for "resources.manage.authors", resource_slug: @resource, author: author.slug
	}

	[invite_reply: "/invite_reply"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			if @rights.user_confirmed
				return error_bad_request @, i18n "resources.manage.errors.invite_already_accepted"

			assert_csrf_token @
			assert_valid @params, {
				{"accept_state", exists: true, one_of: {"true", "false"}}
			}

			if @params.accept_state == "true"
				@rights\update user_confirmed: true
				return redirect_to: @url_for "resources.manage.dashboard", resource_slug: @resource

			@rights\delete!
			redirect_to: @url_for "resources.view", resource_slug: @resource
	}