extends Node

# Path to save user data locally
var local_storage_path = "res://SAVES/save_state.json"
var is_loading_data = false  # Flag to prevent recursive loading

# Save user data locally, including progress
func save_user_data_locally(email: String, user_id: String, username: String, id_token: String, progress: Dictionary) -> void:
	var json_data = {
		"email": email,
		"uid": user_id,
		"username": username,
		"id_token": id_token,
		"progress": progress
	}

	var dir = DirAccess.open("res://SAVES/")
	if not dir or not dir.dir_exists("res://SAVES/"):
		DirAccess.make_dir_absolute("res://SAVES/")

	var file = FileAccess.open(local_storage_path, FileAccess.WRITE_READ)
	if file:
		# Clear file by seeking to the beginning and overwriting it
		file.seek(0)  # Seek to the beginning of the file
		var json_string = JSON.stringify(json_data, "\t")
		file.store_string(json_string)  # Store the new JSON data
		file.close()
		print("✅ User data saved locally.")

		# Use BackupSave autoload to store a backup file only if data has changed
		if progress != {}:  # Only create backup if progress data exists
			BackupSave.create_backup_save(email, user_id, username, id_token, progress)
		else:
			print("ℹ️ No progress data to backup.")
	else:
		print("❌ Could not save user data locally.")

# Load user data (with backup priority)
func load_user_data_with_backup_priority() -> Dictionary:
	# Prevent recursion during data loading
	if is_loading_data:
		return {}

	is_loading_data = true  # Prevent recursion during data load
	const SAVE_DIR := "res://SAVES/"

	# Check if backup file exists for the user
	var backup_path = SAVE_DIR + "backup_" + get_current_user_id() + ".json"
	var user_data = {}

	if FileAccess.file_exists(backup_path):
		# Load backup data if exists
		var file = FileAccess.open(backup_path, FileAccess.READ)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if typeof(data) == TYPE_DICTIONARY:
			print("✅ Loaded backup data.")
			user_data = data
		else:
			print("❌ Could not parse backup data.")
		file.close()
	else:
		print("ℹ️ No backup found, loading local data.")

		# If no backup exists, load the local data
		if FileAccess.file_exists(local_storage_path):
			var file = FileAccess.open(local_storage_path, FileAccess.READ)
			var content = file.get_as_text()
			var data = JSON.parse_string(content)
			if typeof(data) == TYPE_DICTIONARY:
				print("✅ Loaded local user data.")
				user_data = data
			else:
				print("❌ Could not parse local user data.")
			file.close()

	is_loading_data = false  # Allow future data loads
	return user_data

# Reset user data to empty structure, but keep other user information intact
func reset_user_data() -> void:
	const SAVE_DIR := "res://SAVES/"

	if FileAccess.file_exists(local_storage_path):
		var file = FileAccess.open(local_storage_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()

		var data = JSON.parse_string(content)
		if typeof(data) == TYPE_DICTIONARY:
			# Retrieve backup data to prioritize it
			var backup_data = load_user_data_with_backup_priority()

			# Merge the backup data with the local data, prioritizing backup data
			data["progress"] = backup_data.get("progress", {})  # Use progress from backup if available
			data["email"] = backup_data.get("email", data["email"])  # Use email from backup if available
			data["uid"] = backup_data.get("uid", data["uid"])  # Use UID from backup if available
			data["username"] = backup_data.get("username", data["username"])  # Use username from backup if available
			data["id_token"] = backup_data.get("id_token", data["id_token"])  # Use id_token from backup if available

			var write_file = FileAccess.open(local_storage_path, FileAccess.WRITE)
			if write_file:
				write_file.store_string(JSON.stringify(data, "\t"))
				write_file.close()
				print("✅ User data reset, using backup data.")

				# Update the backup with the latest data (including progress)
				BackupSave.create_backup_save(data["email"], data["uid"], data["username"], data["id_token"], data["progress"])
			else:
				print("❌ Could not reopen file for writing.")
		else:
			print("❌ Failed to parse the save file!")
	else:
		print("❌ Save file not found!")

# Retrieve the latest user data (for use in FirestoreManager)
func get_latest_user_data() -> Dictionary:
	return load_user_data_with_backup_priority()

# Set the ID token and save it to local user data
func set_id_token(token: String) -> void:
	var data = load_user_data_with_backup_priority()
	data["id_token"] = token
	save_user_data_locally(data["email"], data["uid"], data["username"], token, data["progress"])
	print("🔐 ID Token set and saved locally.")

# Helper function to get the current user ID (you can adjust this logic as needed)
func get_current_user_id() -> String:
	var data = load_user_data_with_backup_priority()
	return data.get("uid", "unknown_user")
