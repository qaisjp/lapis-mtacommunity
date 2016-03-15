en:
	are_you_sure: "Are you sure?"
	warning: "Warning!"
	since: "Since"

	layout:
		logout: "logout"

	homepage:
		learn_more: "Learn more"
		browse_resources: "Browse resources"
		main:
			first: [[Multi Theft Auto is a multiplayer modification for Rockstar's Grand Theft Auto game series: a piece of software that adapts the game in such a way, you can play Grand Theft Auto with your friends online and develop your own gamemodes.]],
			second: [[It was brought into life because of the lacking multiplayer functionality in the Grand Theft Auto series of games, and provides a completely new platform on-top of the original game, allowing for players to play all sorts and types of game-modes anywhere they want, and developers to develop using our very powerful scripting engine.]]
	
	resources:
		latest_resources: "Latest resources"
		type: "Type"
		cards:
			last_updated: "Last updated"
		overview:
			most_downloaded: "Most Downloaded"
		table:
			name: "Name"
			description: "Description"
			downloads: "Downloads"
			rating: "Rating"
		manage:
			author:
				delete_self: "If you delete yourself as an author, you won't be able to use this page anymore. Be careful."
				make_invite: "Invite author"
				own_permissions: "%{name}'s permissions"
				perm_dashboard_note: "All authors can view the resource dashboard"
				right: "right"
				right_value: "value"
				update_perms_button: "Update permissions"
				delete_button: "Delete author"
				delete_confirm: "Are you sure you want to remove this user as an author?"
				invite_button: "Invite..."

				authors_list: "List of authors"
				authors_list_empty: "This resource has no co-authors."
				authors_invited: "Invited authors"
				authors_invited_empty: "This resource has no pending invites for authorship."

			errors:
				resource_already_exists: "Resource already exists"
				invalid_name: "Invalid resource name"

				no_package: "That's not your package."
				not_create_package: "Could not create package"

				no_screenshot: "That screenshot does not exist"
				invalid_file_type: "Invalid file type"
				not_create_screenshot: "Could not create screenshot"
				image_not_served: "An image should have been served. Sorry about that."

				not_find_author: "Cannot find author \"%{name}\""
				not_existing_author: "\"%{name}\" is not an existing author"
				already_author: "\"%{name}\" is already an author"

				invite_accept_first: "Please accept your invite first"
				invite_already_accepted: "You have already accepted your invite"
		errors:
			friendly_cast_vote: "We're sorry we couldn't cast that vote for you."
			friendly_serve_file: "We're sorry we couldn't serve you that file."
			dependencies_unavailable: "One of the resource dependencies you tried to download was unavailable."

	comment:
		title:
			one: "Comment"
			many: "Comments"
		deleted: "deleted"
		reply_message: "Comment reply message"
		message_placeholder: "Place your comment here"
		user_replied: "replied"
		user_commented: "commented"
		user_modified: "modified"
		errors:
			friendly_create: "We're sorry we couldn't make that comment for you."
			parent_missing: "Parent comment not found"
			cannot_reply_to_reply: "Cannot reply to a comment reply"

	screenshots:
		uploaded_since: "uploaded"

	users:
		action_follow: "Follow"
		action_unfollow: "Unfollow"
		confirm_follow: "Are you sure you want to follow \"%{name}\"?"
		confirm_unfollow: "Are you sure you want to unfollow \"%{name}\"?"

		member_for_duration: "Member for %{duration}"
		card_follow_time: "Following for %{duration}"
		private_profile: "This user's profile is private."
		gravatar_alt: "%{name}'s avatar"

		tab_resources: "Resources"
		tab_followers: "Followers"
		tab_following: "Following"
		tab_comments: "Comments"
		tab_screenshots: "Screenshots"

		manage_user: "Manage user"
		edit_profile: "Edit profile"

		website: "Website"
		gang: "Gang"
		location: "Location"
		cakeday: "Birthday"
		profile_buttons: "Profile Buttons"

		errors:
			not_exist: "User does not exist"
			invalid_name: "Invalid username"
			account_exists: "Account already exists"

			friendly_update_profile: "We're sorry we couldn't make those changes."
			friendly_delete_account: "We're sorry we couldn't delete your account."
			friendly_rename_account: "We're sorry we couldn't rename your account."
			friendly_change_password: "We're sorry we couldn't change your password."
			old_password_mismatch: "Your old password is incorrect."

			cannot_follow_self: "You cannot follow yourself."
			already_following: "You are already following this person"
			not_currently_following: "You are not following this person"

			bad_credentials: "Incorrect username or password."
			not_activated: "Your account has not been activated."
			banned: "You are banned."

	settings:
		username: "Username"
		profile: "Profile"
		account: "Account"

		privacy: "Privacy"
		public: "Public"
		privacy_note: "This only affects your profile page. Everyone will be able to see your comments and see in others' list that they follow you."
		following_only: "Following Only"
		update_section: "Update Section"

		changepass_title: "Change your password"
		old_pass: "Old password"
		new_pass: "New password"
		confirm_new_pass: "Confirm new password"
		changepass_button: "Change password"
		
		rename_title: "Change username"
		rename_info: "Your old username becomes available for other people to register. No redirections will be set up."
		rename_button: "Change username..."
		rename_confirm: "Are you sure you want to change your username?"

		delete_info: "Deleting your account removes all resources, names from your comments, and screenshots. The username also becomes available for other people to register."
		delete_button: "Delete account..."
		delete_confirm: "Are you sure you want to delete your account? This is permanent."


	auth:
		login_title: "Login"
		register_title: "Register"
		reset_title: "Reset your password"
		
		username_placeholder: "username"
		password_placeholder: "password"
		confirm_password_placeholder: "confirm"
		email_placeholder: "email address"

		register_button: "register"
		login_button: "login"

		register_title: "Register an account"
		register_success: "Account successfully created. Your account has been automatically activated."

		need_logged_in: "You need to be logged in to do that."

	search:
		title: "Search"
		
		field_placeholder: "short or long name"
		sr_field_name: "Name"

		in_description: "Search in description"
		results_header: "Search Results"
		no_results: "No resources match your search query"

	errors:
		max_filesize: "Max filesize is %{max}. Your file is %{ours} bytes"
		bad_request:
			title: "Bad Request"
			h1: "400: Bad Request"
			h3: "This is not the right page you're looking for."
		not_authorized:
			title: "Not Authorized"
			h1: "Sorry, you can't access this page."
		not_found:
			title: "Page not found"
			h1: "404: Sorry, this page isn't available"
			h3: "The page doesn't exist, but it might have in the past, and it might in the future!"
		method_disallowed:
			title: "Error 405"
			h1: "405: Sorry, this page isn't available"
			h3: "The page doesn't exist, but it might have in the past, and it might in the future!"
		server_error:
			title: "Oops"
			h3: "Something went wrong."
		internal_error_output: "Internal error. Give the following information to a codemonkey:"