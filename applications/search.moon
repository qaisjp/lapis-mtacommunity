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
			{ "name", on_exist: argChecker }
			{ "type", optional: true, one_of: {"script", "map", "gamemode", "misc", "any"} }
			{ "author", on_exist: argChecker }
			{ "showAmount", exists: true, is_integer: true, between: {1, 100} }
		}, keys: true

		if @errors
			if @errors.showAmount
				@params.showAmount = DEFAULT_SHOW_AMOUNT
				@errors.showAmount = nil

			local hasErrors
			if hasSearchArguments
				for _ in pairs @errors
					hasErrors = true
					break
			else
				hasErrors = true
				@errors = nil
				@not_searched = true

		return render: true if hasErrors

		searchingDescription = (@params.description == "true") and true or false
		@params.description = searchingDescription

		similarityMode = searchingDescription and "description" or "name"

		-- We might not have either param.
		unless @params[similarityMode]
			@not_searched = true
			return render: true


		fields, query = "*", "WHERE 1=1"
		-- Where same type
		if type = @params.type
			query..= db.interpolate_query " AND (type = ?)", Resources.types[type] unless type == "any"

		if not searchingDescription -- WHEN SEARCHING INSIDE NAMES
			-- Selecting similarity of name
			fields..= db.interpolate_query ", similarity(name, ?) as nameSimilarity, similarity(longname, ?) as longSimilarity", @params.name, @params.name
		
			-- Where names similar
			query ..= db.interpolate_query " AND ((name % ?) or (longname % ?))", @params.name, @params.name

			-- Order by similarity
			query ..= " ORDER BY nameSimilarity DESC"
		else
			fields..= db.interpolate_query ", similarity(description, ?)", @params.name
			query ..= db.interpolate_query " AND (description LIKE ?)", @params.name

			-- Order by similarity
			-- query ..= " ORDER BY similarity DESC"

		-- Limit the number of results returned
		limit = tonumber(@params.showAmount) or DEFAULT_SHOW_AMOUNT
		query..= " LIMIT " .. limit

		@query = fields.." | "..query

		@resourceList = Resources\select query, :fields
		render: true			