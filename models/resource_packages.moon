import Model from require "lapis.db.model"

class ResourcePackages extends Model
    -- Has created_at and modified_at
    @timestamp: true
    @relations: {
    	{"dependencies", has_many: "PackageDependencies", id: "source_package"}
    }