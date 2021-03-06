package = "mtacommunity"
version = "1.0.0-1"
source = {
   url = "https://github.com/qaisjp/mtacommunity"
}
description = {
   summary = "MTA Community",
   license = "MIT"
}

dependencies = {
	"lua ~> 5.1",
	"lapis",
	"luafilesystem",
	"date",
	"mailgun",
	"bcrypt",
	"i18n"
}

build = {
	type = "none"
}
