lapis = require "lapis"
db    = require "lapis.db"
import
	Resources
	ResourcePackages
	ResourceAdmins
	Users
	Comments
from require "models"
import
	error_404
	error_405
	error_500
	error_not_authorized
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

class ManageResourceApplication extends lapis.Application
	path: "/:resource_slug/manage"
	name: "manage."

	@before_filter =>
		if not check_logged_in @
			return

		@rights = @resource\get_rights @active_user
		unless @rights
			return @write error_not_authorized @

		@right_names = {"can_configure", "can_moderate", "can_manage_authors", "can_manage_packages", "can_upload_screenshots"}

		-- see views.resources.manage.layout to add sections
		@tabs = {
			dashboard: true,
			details: @rights.can_configure
			settings: @resource.creator == @active_user.id
			authors: @rights.can_manage_authors
		}

	check_tab: =>
		unless @tabs[@params.tab]
			return error_404 @, "Nothing to manage here..."

	["":""]: => redirect_to: @url_for "resources.manage.dashboard", resource_slug: @resource
	
	[dashboard: "/dashboard"]: capture_errors {
		before: => @check_tab @
		on_error: error_500
		=> render: "resources.manage.layout"
	}

	[details: "/details"]: capture_errors {
		before: => @check_tab @
		on_error: error_500
		=> render: "resources.manage.layout"
	}

	[settings: "/settings"]: capture_errors {
		before: => @check_tab @
		on_error: error_500
		=> render: "resources.manage.layout"
	}

	[authors: "/authors(/:author)"]: capture_errors {
		before: => @check_tab @
		on_error: error_500
		=>
			unless @tabs.authors
				return error_not_authorized @

			if author_slug = @params.author
				while true do
					@author = Users\find slug: author_slug
					unless @author
						@errors = {"Cannot find author \"#{author_slug}\""}
						break -- continue to render

					@author_rights = @resource\get_rights @author
					if (not @author_rights) or (@author.id == @resource.creator)
						@author_rights = nil
						@author = nil
						@errors = {"\"#{author_slug}\" is not an existing author"}
						break

					break -- always continue to render, no loop!

			render: "resources.manage.layout"
	}

	["update_description": "/update_description"]: capture_errors respond_to {
		on_error: error_500
		GET: error_405
		POST: =>
			unless @tabs.details
				return error_not_authorized @

			assert_csrf_token @

			@resource.description = @params.resDescription
			@resource\update "description"

			-- refresh
			redirect_to: @url_for "resources.manage.details", resource_slug: @resource
	}

	["transfer_ownership": "/transfer_ownership"]: capture_errors respond_to {
		on_error: error_500
		GET: error_405
		POST: =>
			unless @tabs.settings
				return error_not_authorized @

			assert_csrf_token @

			-- check if new owner exists

			-- future: 
				-- send email to existing owner
				-- link in email will send request to new owner
				-- newOwner accepts request to become owner

			-- make new owner the owner

			-- redirect to main resource page (we no longer have permissions)
			redirect_to: @url_for @resource
	}

	["rename": "/rename"]: capture_errors respond_to {
		on_error: error_500
		GET: error_405
		POST: =>
			unless @tabs.settings
				return error_not_authorized @

			assert_csrf_token @

			-- check if new resource name exists
			-- update resource name

			-- refresh
			redirect_to: @url_for "resources.manage.settings", resource_slug: @resource
	}

	["delete": "/delete"]: capture_errors respond_to {
		on_error: error_500
		GET: error_405
		POST: =>
			unless @tabs.settings
				return error_not_authorized @

			assert_csrf_token @

			-- check if new resource name exists

			-- refresh
			redirect_to: @url_for "resources.overview"
	}

	["delete_author": "/delete_author"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			unless @tabs.authors
				return error_not_authorized @

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

	["update_author_rights": "/update_author_rights"]: capture_errors respond_to {
		on_error: => error_500 @, @errors[1]
		GET: error_405
		POST: =>
			unless @tabs.authors
				return error_not_authorized @

			assert_csrf_token @
			assert_valid @params, {
				{ "author", exists: true }
			}

			author = Users\find slug: @params.author
			yield_error "Cannot find author \"#{@params.author}\"" unless author

			rightsObj = ResourceAdmins\find resource: @resource.id, user: author.id
			if (not rightsObj) or (author.id == @resource.creator)
				yield_error "\"#{author_slug}\" is not an existing author"

			for right in *@right_names
				rightsObj[right] = (@params[right] == "true")

			rightsObj\update unpack @right_names

			redirect_to: @url_for "resources.manage.authors", resource_slug: @resource, author: author.slug
	}