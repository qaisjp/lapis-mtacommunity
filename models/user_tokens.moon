import Model from require "lapis.db.model"

class UserTokens extends Model
    -- Has created_at and modified_at
    @timestamp: true
    