lapis = require "lapis"

Users = require "models.users"

class extends lapis.Application
    @include "applications.users"
    
    [home: "/"]: =>
        "Welcome to... Lapis #{require "lapis.version"}!"

    


