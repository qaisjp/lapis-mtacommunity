db   = require "lapis.db"
i18n = require "i18n"
import Model, enum from require "lapis.db.model"
import Users from require "models"

import trim from require "lapis.util"

slugify_resource_name = (name) ->
	import slugify from require "lapis.util"
	slugify name

trueTable = setmetatable {},
	__index: -> true
	__newindex: -> error("attempting to change readonly trueTable", 2)
	
class Resources extends Model
	-- Has created_at and updated_at
	@timestamp: true

	@relations: {
		{"comments", has_many: "Comments", key: "resource", order: "created_at desc", where: deleted: false}
		{"screenshots", has_many: "ResourceScreenshots", key: "resource", order: "created_at desc"}
		{"packages", has_many: "ResourcePackages", key: "resource", order: "created_at desc"}
	}

	@types: enum
		gamemode: 1
		script: 2
		map: 3
		misc: 4

	url_key: (route_name) => @slug
	url_params: (reg, ...) => "resources.view", { resource_slug: @ }, ...

	@is_name_available: (name) =>
		assert name, "no name in is_name_available"
		name = trim name
		
		if name == ""
			return nil, i18n "resources.manage.errors.invalid_name"

		if @check_unique_constraint [db.raw "lower(name)"]: name\lower!
			return nil, i18n "resources.manage.errors.already_exists"
			
		slug = slugify_resource_name name
		if @check_unique_constraint [db.raw "lower(slug)"]: slug\lower!
			return nil, i18n "resources.manage.errors.already_exists"
		
		name, slug

	rename: (name) =>
		name, slug = Resources\is_name_available name
		return nil, slug unless name

		@update :name, :slug
		true

	-- all authors
	get_authors: (opts = {}) =>
		Users\select [[
			-- The columns we're looking through...
			, resources, resource_admins

			WHERE
			(
			]] .. (
				-- Is the user the creator?
				-- opts.include_creator defaults to true
				(opts.include_creator != true) and "(0 = 1)" or "(resources.creator = users.id)"
			) .. [[
				OR
				(
					(resource_admins.user = users.id) -- Make sure they are an admin...
					AND (resource_admins.resource = resources.id) -- ... of the correct resource...
					AND ]] .. (
						(opts.is_confirmed == nil) and "(1 = 1)" or "(resource_admins.user_confirmed = #{db.escape_literal opts.is_confirmed})"
					) .. [[ -- but make sure they've confirmed the request!
				)
			)

			-- Make sure we're looking through the right resource
			AND (resources.id = ?)

			-- Prevent duplicates
			GROUP BY users.id
		]], @id, fields: opts.fields or "users.*"

	is_user_admin: (user, opts={}) =>
		(db.select [[
			EXISTS(
				SELECT 1 FROM users, resources, resource_admins
				WHERE
				(
					-- Is the user the creator
					(resources.creator = users.id)

					OR
					(
						(resource_admins.user = users.id) -- Make sure they are an admin...
						AND (resource_admins.resource = resources.id) -- ... of the correct resource...
						AND ]] .. (
							(opts.is_confirmed == nil) and "(1 = 1)" or "(resource_admins.user_confirmed = #{db.escape_literal opts.is_confirmed})"
						) .. [[ -- but make sure they've confirmed the request!
					)
				)

				-- Make sure we're looking through the right resource
				AND (resources.id = ?)

				-- And checking the right person
				AND (users.id = ?)
			)]], @id, user.id
		)[1].exists

	get_rights: (user, user_confirmed) =>
		return trueTable if @creator == user.id
		import ResourceAdmins from require "models"
		ResourceAdmins\find resource: @id, user: user.id, :user_confirmed