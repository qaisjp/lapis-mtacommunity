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
	serve_file
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

		if not @resource\is_user_admin @active_user
			return @write error_not_authorized @

		@rights = @resource\get_rights @active_user

	["": "(/:tab)"]: capture_errors respond_to {
		on_error: error_500
		GET: =>
			@params.tab = @params.tab or "dashboard"

			tabs = {
				dashboard: true,
				settings: true,
				details: true
			}
			unless tabs[@params.tab]
				return error_404 @

			render: "resources.manage.layout"
	}