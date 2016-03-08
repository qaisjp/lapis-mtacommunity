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
	name: "manage"

	@before_filter =>
		if not check_logged_in @
			return

		@rights = @resource\get_rights @active_user
		unless @rights
			return @write error_not_authorized @

		@tabs = {
			dashboard: true,
			details: @rights.can_configure
			settings: @resource.creator == @active_user.id,
		}

	[".update_description": "/update_description"]: capture_errors respond_to {
		on_error: error_500
		GET: error_405
		POST: =>
			unless @tabs.details
				return error_not_authorized @

			@resource.description = @params.resDescription
			@resource\update "description"

			-- refresh
			redirect_to: @url_for "resources.manage", resource_slug: @resource, tab: "details"
	}

	[".transfer_ownership": "/transfer_ownership"]: capture_errors respond_to {
		on_error: error_500
		GET: error_405
		POST: =>
			unless @tabs.settings
				return error_not_authorized @

			-- check if new owner exists

			-- future: 
				-- send email to existing owner
				-- link in email will send request to new owner
				-- newOwner accepts request to become owner

			-- make new owner the owner

			-- redirect to main resource page (we no longer have permissions)
			redirect_to: @url_for @resource
	}

	[".rename": "/rename"]: capture_errors respond_to {
		on_error: error_500
		GET: error_405
		POST: =>
			unless @tabs.settings
				return error_not_authorized @

			-- check if new resource name exists
			-- update resource name

			-- refresh
			redirect_to: @url_for "resources.manage", resource_slug: @resource, tab: "settings"
	}

	[".delete": "/delete"]: capture_errors respond_to {
		on_error: error_500
		GET: error_405
		POST: =>
			unless @tabs.settings
				return error_not_authorized @

			-- check if new resource name exists

			-- refresh
			redirect_to: @url_for "resources.overview"
	}

	["": "(/:tab)"]: capture_errors {
		on_error: error_500
		=>
			@params.tab = @params.tab or "dashboard"

			unless @tabs[@params.tab]
				return error_404 @, "Nothing to manage here..."

			render: "resources.manage.layout"
	}