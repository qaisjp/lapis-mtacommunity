import Model, enum from require "lapis.db.model"

class UserTokens extends Model
    -- Has created_at and modified_at
    @timestamp: true
    @token_type: enum
		reset_password: 1