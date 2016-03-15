import from_json from require "lapis.util"
i18n = require "i18n"

check_resource_file = (file) ->
	-- open up a feed
	output, err = io.popen "../mtacommunity-cli/mtacommunity-cli check --file=#{file}"

	-- if it failed to open...
	return false, {"Internal error..."} unless output

	-- read all the possible errors...
	errors = {}
	local success
	for line in output\lines! do
		-- did we have a reportable error?
		if line\sub(1, 7) == "error: "
			success = false
			table.insert errors, line\sub 8

		-- are we done? is everything okay?
		elseif line\sub(1, 2) == "ok"
			couldDecode, decoded = pcall from_json, line\sub 3

			if not couldDecode
				errors = {"#{i18n 'errors.internal_error_output'}:", decoded, line\sub 3}
			elseif success != false
				success = decoded

			break

		-- we got something else...
		else
			success = false
			errors  = {"Internal error..."}
			break
	
	output\close!
	return success, errors


-- general function to build a path relative to the web root for packages
build_package_filepath = (resource, pkg, file) ->
	"uploads/#{resource}/packages/#{pkg}.#{file}"

-- general function to build a path relative to the web root for screenshots
build_screenshot_filepath = (resource, screenie_id, file) ->
	"uploads/#{resource}/screenshots/#{screenie_id}.#{file}"

-- generate statements for renaming in zipnote comments
build_rename_comment = (oldname, newname) ->
	"@ #{oldname}\n@=#{newname}\n@ (comment above this line)\n"

{:check_resource_file, :build_package_filepath, :build_screenshot_filepath, :build_rename_comment}