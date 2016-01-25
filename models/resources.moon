import Model, enum from require "lapis.db.model"

class Resources extends Model
    -- Has created_at and modified_at
    @timestamp: true
    @types: enum
    	gamemode: 1
    	script: 2
    	map: 3
    	misc: 4