lapis = require "lapis"
db = require "lapis.db"
import Resources from require "models"
import trim_filter from require "lapis.util"
import validate, validate_functions from require "lapis.validate"

DEFAULT_SHOW_AMOUNT = 15

-- This validator will call whatever function passed
-- if the function exists... using closures!
validate_functions.on_exist = (input, fn) ->
	fn() if input and input != ""
	true

validate_functions.between = (input, lower, upper) ->
	input = tonumber(input)
	if not input
		return false, "%s is not a number"
	(input >= lower) and (input <= upper), "%s must be between " .. lower .. " and " .. upper

class SearchApplication extends lapis.Application
	[search: "/search"]: =>
		trim_filter @params
		
		hasSearchArguments = false
		argChecker = -> hasSearchArguments = true
		@errors = validate @params, {
			{ "name", "You must enter a name", exists: true, on_exist: argChecker }
			{ "type", one_of: {"script", "map", "gamemode", "misc", "any"} }
			{ "description", on_exist: argChecker }
			{ "author", on_exist: argChecker }
			{ "showAmount", exists: true, is_integer: true, between: {1, 100} }
		}, keys: true

		if @errors
			if @errors.showAmount
				@params.showAmount = DEFAULT_SHOW_AMOUNT
				@errors.showAmount = nil

			hasErrors = not hasSearchArguments
			for _ in pairs @errors
				hasErrors = true
				break

		return render: true if hasErrors

		-- Selecting similarity of name
		-- todo do long name similarity
		query = db.interpolate_query "*, similarity(name, ?) as nameSimilarity", @params.name

		-- Selecting similarity of description
		if desc = @params.description
			query..= db.interpolate_query ", similarity(description, ?) as descrSimilarity", desc

		-- Where names similar
		query..= db.interpolate_query " WHERE name % ?", @params.name

		-- Where same type
		if type = @params.type
			query..= db.interpolate_query " AND type = ?", Resources.types[type] unless type == "any"

		-- Order by similarity
		similarity = "(nameSimilarity" -- note opening bracket here
		similarity..= " + descrSimilarity" if @params.description
		query..= " ORDER BY #{similarity}) DESC"

		-- Limit the number of results returned
		limit = tonumber(@params.showAmount) or DEFAULT_SHOW_AMOUNT
		query..= " LIMIT " .. limit


		@resourceList = Resources\select query
		render: true			