import Model from require "lapis.db.model"

class Comments extends Model
	-- @relations:
		-- {"author", belongs_to: "Users", key: "author"}

    -- Has created_at and modified_at
    @timestamp: true
    