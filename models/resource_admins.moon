import Model from require "lapis.db.model"

class ResourceAdmins extends Model
    -- Has created_at and modified_at
    @timestamp: true
    @primary_key: { "resource", "user" }
    