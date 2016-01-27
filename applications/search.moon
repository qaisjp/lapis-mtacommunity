lapis = require "lapis"
db = require "lapis.db"
import Resources from require "models"
import trim_filter from require "lapis.util"
import validate, validate_functions from require "lapis.validate"

DEFAULT_SHOW_AMOUNT = 15

validate_functions.between = (input, lower, upper) ->
	input = tonumber(input)
	if not input
		return false, "%s is not a number"
	(input >= lower) and (input <= upper), "%s must be between " .. lower .. " and " .. upper

class SearchApplication extends lapis.Application
	[search: "/search"]: =>
		trim_filter @params
		
		hasSearchArguments = false
		@errors = validate @params, {
			{ "name", exists: true }
			{ "type", optional: true, one_of: {"script", "map", "gamemode", "misc", "any"} }
			-- { "author", optional: true }
			{ "showAmount", exists: true, is_integer: true, between: {1, 100} }
		}, keys: true

		if @errors
			if @errors.showAmount
				@params.showAmount = DEFAULT_SHOW_AMOUNT
				@errors.showAmount = nil

			local hasErrors
			if @errors.name
				hasErrors = true
				@errors = nil
				@not_searched = true
			else
				for _ in pairs @errors
					hasErrors = true
					break
			return render: true if hasErrors

		searchingDescription = (@params.description == "true") and true or false
		@params.description = searchingDescription and "true" or nil

		similarityMode = searchingDescription and "description" or "name"

		-- We might not have either param.
		unless @params[similarityMode]
			@not_searched = true
			return render: true


		fields, query = "resources.*", " WHERE 1=1"
		-- Where same type
		if type = @params.type
			query..= db.interpolate_query " AND (type = ?)", Resources.types[type] unless type == "any"

		if author = @params.author
			query = ", users" .. query
			query..= db.interpolate_query " AND (resources.creator = users.id) AND (users.username % ?)", author

		if not searchingDescription -- WHEN SEARCHING INSIDE NAMES
			-- Get the total similarity of both names (0 to 2 value)
			fields..= db.interpolate_query ", (similarity(name, ?) + similarity(longname, ?)) as similarity", @params.name, @params.name
		
			-- Where names similar
			query ..= db.interpolate_query " AND ((name % ?) or (longname % ?))", @params.name, @params.name
		else
			-- Get the similarity of just the description
			fields..= db.interpolate_query ", similarity(description, ?)", @params.name
			
			-- Find where given description is similarish
			query ..= db.interpolate_query " AND (description <-> ?) < 0.9", @params.name

		-- Order by similarity
		query ..= " ORDER BY similarity DESC"

		-- Limit the number of results returned
		limit = tonumber(@params.showAmount) or DEFAULT_SHOW_AMOUNT
		query..= " LIMIT " .. limit

		@query = fields.." | "..query

		@resourceList = Resources\select query, :fields
		render: true			