import Model from require "lapis.db.model"
i18n = require "i18n"

class ResourcePackages extends Model
    -- Has created_at and modified_at
    @timestamp: true
    @relations: {
    	{"dependencies", has_many: "PackageDependencies", id: "source_package"}
    }


    -- check the an uploaded file is small enough
	@check_file_size: (posted_file) =>
		size = #posted_file.content
		if size > 20 * 1000 * 1000
			return nil, i18n "errors.max_filesize", max: "20Mb", ours: size
		true

	-- get the filepath of a resource that is uploaded
	@build_filepath: (resource, pkg, file) =>
		import build_package_filepath from require "helpers.uploads"
		build_package_filepath resource, pkg, file