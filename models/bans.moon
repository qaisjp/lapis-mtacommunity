import Model from require "lapis.db.model"
db = require "lapis.db"
class Bans extends Model
    -- Has created_at and modified_at
    @timestamp: true

    -- Relations
    @relations: {
        {"receiver", belongs_to: "Users", key: "banned_user"}
        {"sender", belongs_to: "Users", key: "banner"}
    }

    -- refresh all the bans ever (or just for the given user)
    @refresh_bans: (user) =>
        -- todo: just use an update query rather than selecting and then updating. use db.query
        db.query [[
            UPDATE bans SET active = false WHERE
                (active = true)
                AND (now() at time zone 'utc' > expires_at)
        ]] .. (user and "AND banned_user = #{user.id}" or "")