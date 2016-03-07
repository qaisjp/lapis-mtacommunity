db = require "lapis.db"
import Model, enum from require "lapis.db.model"
import Users from require "models"

trueTable = setmetatable {},
    __index: -> true
    __newindex: -> error("attempting to change readonly trueTable", 2)
class Resources extends Model
    -- Has created_at and updated_at
    @timestamp: true

    @relations: {
    	{"comments", has_many: "Comments", key: "resource", order: "created_at desc", where: deleted: false}
        {"packages", has_many: "ResourcePackages", key: "resource", order: "created_at desc"}
    }

    @types: enum
    	gamemode: 1
    	script: 2
    	map: 3
    	misc: 4

    get_authors: (fields = "users.*") =>
    	Users\select [[
    		-- The columns we're looking through...
    		, resources, resource_admins

    		WHERE
    		(
    			-- Is the user the creator
	    		(resources.creator = users.id)

	    		OR
	    		(
	    			(resource_admins.user = users.id) -- Make sure they are an admin...
	    			AND (resource_admins.resource = resources.id) -- ... of the correct resource...
	    			AND (resource_admins.user_confirmed) -- but make sure they've confirmed the request!
	    		)
    		)

			-- Make sure we're looking through the right resource
			AND (resources.id = ?)

			-- Prevent duplicates
			GROUP BY users.id
    	]], @id, :fields

    is_user_admin: (user) =>
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
                        AND (resource_admins.user_confirmed) -- but make sure they've confirmed the request!
                    )
                )

                -- Make sure we're looking through the right resource
                AND (resources.id = ?)

                -- And checking the right person
                AND (users.id = ?)
            )]],  @id, user.id
        )[1].exists

    get_rights: (user) =>
        return trueTable if @creator == user.id
        import ResourceAdmins from require "models"
        rights = ResourceAdmins\find resource: @id, user: user.id, user_confirmed: true
        right or {}