db = require "lapis.db"
import Model, enum from require "lapis.db.model"
import Users from require "models"

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
    
    can_user: (user, perm) => false
        -- perm = column name (check with validate for a selection of column names)
        -- sql query should return 1 if:
        -- > user is a creator of this resource
        -- > or user has the perm for this resource

