en:
	are_you_sure: "Are you sure?"
	view: "View"
	update: "Update"
	delete: "Delete"
	download: "Download"

	warning: "Warning!"
	success: "Success!"

	since: "Since"
	next: "Next"
	previous: "Previous"

	email:
		reset:
			subject: "Reset community password"
			h1: "Reset your password"
			note: "Someone requested a password reset. Simply ignore this email if you didn't request this."

	layout:
		logout: "logout"

	homepage:
		learn_more: "Learn more"
		browse_resources: "Browse resources"
		main:
			first: "Multi Theft Auto is a multiplayer modification for Rockstar's Grand Theft Auto game series: a piece of software that adapts the game in such a way, you can play Grand Theft Auto with your friends online and develop your own gamemodes.",
			second: "It was brought into life because of the lacking multiplayer functionality in the Grand Theft Auto series of games, and provides a completely new platform on-top of the original game, allowing for players to play all sorts and types of game-modes anywhere they want, and developers to develop using our very powerful scripting engine."
	
	resources:
		title: "Resources"
		latest_resources: "Latest resources"
		view_resource: "View resource"
		type: "Type"

		cast_vote: "Cast vote"

		cards:
			last_updated: "Last updated"

		overview:
			most_downloaded: "Most Downloaded"
			best_resources: "Best Resources"
			recently_uploaded: "Recently Uploaded"

		upload:
			title: "Upload a new resource"
			existing_update_alert: "If you'd like to update an existing resource, visit the manager for the resource."
			name_info: "The name of the resource file (admin, editor, freeroam, race, hedit, etc.)"
			description_info: "This will be displayed whenever people visit your resource."
			publish: "Publish Resource"


		
		table:
			name: "Name"
			description: "Description"
			downloads: "Downloads"
			rating: "Rating"
			version: "Version"
			publish_date: "Publish Date"
			changes: "Changes"
			title: "Title" -- pretty much just for screenshots

		get:
			h1: "Downloading %{name} v %{version}"
			momentarily: "Your download should start momentarily."

			please_click: "Please click"
			here: "here"
			if_not_start: "if the download did not start."

			admin_warning: "Do not give administrator rights to any resource unless you trust it."
			dependency_note: "This resource depends on other resources. Please select the resources you would like in your download - you should not need to check resources that you already have. \"%{name}\" will be included in your download."

		manage:
			title: "Manage"
			tab_dashboard: "Dashboard"
			tab_details: "Details"
			tab_packages: "Packages"
			tab_authors: "Authors"
			tab_settings: "Settings"
			tab_screenshots: "Screenshots"

			author:
				title:
					one: "Author"
					many: "Authors"
				moderation_invite: "You have an invite to moderate this resource!"
				accept_invite: "accept"
				decline_invite: "decline"
				
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

			dashboard:
				statistics: "Statistics"
				parent_comments: "Parent comments: %{num}"
				comment_replies: "Comment replies: %{num}"
				not_included_by: "This resource is not included by any other resource."
				is_included_by: "This resource is included by: "

				screenshot_count: "Screenshots: %{num}"
				download_count: "Downloads: %{num}"

			details:
				title: "Details"
				change_description: "Change description"
				description: "Description"
				description_info: "This will be displayed whenever people visit your resource."
				description_button: "Update description"

			packages:
				update_resource: "Update resource"
				description: "Description"
				description_info: "What does this update do? What has changed?"
				changelog: "Change log"
				changelog_info: "What does this update do? What has changed?"
				upload: "Upload"
				upload_success: "Resource successfully uploaded."
				
				not_including: "This package does not include any other resource."
				is_including: "This package includes: "
				include_add: "Add include"
				include_button: "Add"
				include_resource: "resource name"
				include_version: "version?"


			screenshots:
				upload: "Upload screenshot"
				title: "Title"
				title_info: "Summarise your screenshot"
				description: "Description"
				optional: "optional"
				none_uploaded: "No screenshots are currently uploaded."

			settings:
				transfer_ownership: "Transfer ownership"
				transfer_ownership_info: "You will no longer have access to the management section of this resource. You will have to contact the new owner to be given permissions."
				new_owner: "New owner"
				rename_resource: "Rename resource"
				rename_info_first: "The old resource name becomes available for other people to register. No redirections will be set up."
				rename_info_second: "Any existing resources that include your resource will still include your resource for download. These resources will need to be updated to include the new name."
				rename_info_third: "Any newly uploaded resources should have the updated name."
				rename_name: "Name"
				rename_button: "Rename resource..."
				delete: "Delete resource"
				delete_info: "Deleting your resources removes all comments, screenshots and packages. The resource also becomes available for other people to register."
				delete_button: "Delete resource..."

				transfer_ownership_confirm: "Are you sure you want to change transfer ownership?"
				rename_confirm: "Are you sure you want to rename your resource?"
				delete_confirm: "Are you sure you want to delete this resource? This is permanent."

			errors:
				comment_not_exist: "Comment does not exist"
				resource_already_exists: "Resource already exists"
				invalid_name: "Invalid resource name"
				version_search_fail: "Couldn't find that version with that resource"
				package_already_dep: "That package is already a dependency"

				no_package: "That's not your package."
				not_create_package: "Could not create package"
				version_exists: "That version already exists."

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
		sr_parent_message: "Comment message:"
		message_placeholder: "Place your comment here"
		user_replied: "replied"
		user_commented: "commented"
		user_modified: "modified"
		reply: "reply"
		errors:
			friendly_create: "We're sorry we couldn't make that comment for you."
			parent_missing: "Parent comment not found"
			cannot_reply_to_reply: "Cannot reply to a comment reply"

		login_to: "Log in to leave a comment"

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
			token_not_exist: "Cannot reset password - invalid token"
			token_expired: "Password reset token has expired"

			friendly_update_profile: "We're sorry we couldn't make those changes."
			friendly_delete_account: "We're sorry we couldn't delete your account."
			friendly_rename_account: "We're sorry we couldn't rename your account."
			friendly_change_password: "We're sorry we couldn't change your password."
			old_password_mismatch: "Your old password is incorrect."
			password_confirm_mismatch: "Password confirmation incorrect"

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
		reset_send_email: "Send confirmation email"
		reset_email_sent: "An confirmation email has been sent to your address."
		
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

		internal_error: "Internal error."
		internal_error_output: "Internal error. Give the following information to a codemonkey:"