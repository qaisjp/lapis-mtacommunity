import Model from require "lapis.db.model"

class PackageDependencies extends Model
	@primary_key: {"source_package", "package"}