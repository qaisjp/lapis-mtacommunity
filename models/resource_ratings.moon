import Model from require "lapis.db.model"

class ResourceRatings extends Model
    @primary_key: {"resource", "user"}