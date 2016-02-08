-- config.moon
config = require "lapis.config"
secrets = require "secrets"

config "development", ->
	port 8080
	secret secrets.secret
	bcrypt_log_rounds 5
	postgres secrets.postgres
	logging ->
		-- queries false
		-- requests false


config "production", ->
	port 80
	num_workers 4
	code_cache "on"
	bcrypt_log_rounds 5