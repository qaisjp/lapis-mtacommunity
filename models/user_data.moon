import Model from require "lapis.db.model"

class UserData extends Model
	@primary_key: "user_id"
    @relations: {
    	{"user_id", belongs_to: "Users"}
    }
    
    