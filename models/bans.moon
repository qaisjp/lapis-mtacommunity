import Model from require "lapis.db.model"

class Bans extends Model
    -- Has created_at and modified_at
    @timestamp: true

    -- Relations
    @relations: {
    	{"banned_user", belongs_to: "Users", key: "banned_user"}
    	{"banner", belongs_to: "Users", key: "banner"}
    }

    -- refresh all the bans ever (or just for the given user)
    @refresh_bans: (user) =>
        -- todo: just use an update query rather than selecting and then updating. use db.query
    	bans = Bans\select "where active = true AND now() > expires_at" .. (if user then " AND banned_user = ?" else ""), user and user.id or nil
    	for ban in *bans
    		ban\update active: false