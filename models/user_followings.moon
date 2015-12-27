import Model from require "lapis.db.model"

class UserFollowings extends Model
    @primary_key: {"follower", "following"}

    