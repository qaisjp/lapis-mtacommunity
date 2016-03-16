import Model from require "lapis.db.model"

class ResourceReports extends Model
    -- Has created_at and modified_at
    @timestamp: true
    @relations: {
		{"resource", belongs_to: "Resources", key: "resource"}
	}