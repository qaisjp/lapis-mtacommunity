import Model, enum from require "lapis.db.model"
db = require "lapis.db"
date = require "date"

class UserTokens extends Model
    @type: enum
    	register: 1
    	reset_password: 2

    @relations: {
    	{"owner", belongs_to: "Users", key: "id"}
    }

    @create: (token_type, owner, expires_at) =>
    	-- make owner be the id of the user
    	owner = owner.id unless type(owner) == "number"

    	-- first delete any tokens of the type from that user
    	db.delete "user_tokens", :owner, type: UserTokens.type\for_db(token_type)

    	super {
    		id: -- NEEDS GENERATING
    		:owner
    		type: UserTokens.type\for_db token_type
    		:expires_at
    	}

    has_expired: =>
    	-- never expires if expires_at = 0
    	return false unless @expires_at
    	date(@expires_at) < date!