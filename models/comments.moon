import Model from require "lapis.db.model"

class Comments extends Model
    -- Has created_at and modified_at
    @timestamp: true
    