import Users from require "models"

True, False = "[TRUE]", "[FALSE]"

-- default settings
defaults =
  can_use_console: True
  console_level_required: Users.levels.admin
  enable_uploading: True
  enable_commenting: True


defaults
