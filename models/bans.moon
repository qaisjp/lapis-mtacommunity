import Model from require "lapis.db.model"

class Bans extends Model
    -- Has created_at and modified_at
    @timestamp: true

    -- Relations
    @relations: {
    	{"banned_user", has_one: "Users", key: "id"}
    	{"banner", has_one: "Users", key: "id"}
    }

    -- refresh all the bans ever (or just for the given user)
    @refresh_bans: (user) =>
    	bans = Bans\select "where active = true AND now() > expires_at" .. (if user then "banned_user = ?" else ""), user and user.id or nil
    	for ban in *bans
    		ban\update active: false