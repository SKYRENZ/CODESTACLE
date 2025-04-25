extends Node

const SAVE_DIR := "res://SAVES/"
var is_logout_in_progress = false  # Flag to control backup during logout

# Save a backup file using the user's UID
func create_backup_save(email: String, user_id: String, username: String, id_token: String, progress: Dictionary) -> void:
	# Skip backup if logout is in progress
	if is_logout_in_progress:
		print("ℹ️ Skipping backup creation during logout.")
		return
	
	var save_data = {
		"email": email,
		"uid": user_id,
		"username": username,
		"id_token": id_token,
		"progress": progress
	}

	# Ensure SAVE_DIR exists
	var dir = DirAccess.open(SAVE_DIR)
	if not dir:
		DirAccess.make_dir_absolute(SAVE_DIR)

	# Save file path with UID
	var backup_path = SAVE_DIR + "backup_" + user_id + ".json"
	var file = FileAccess.open(backup_path, FileAccess.WRITE_READ)
	if file:
		# Clear the file by seeking to the beginning and overwriting it
		file.seek(0)  # Seek to the beginning of the file
		file.store_string(JSON.stringify(save_data, "\t"))  # Store the new JSON data
		file.close()
		print("✅ Backup created for user: " + user_id)
	else:
		print("❌ Failed to create backup for user.")

# Load backup for a specific user by UID
func load_backup(user_id: String) -> Dictionary:
	var backup_path = SAVE_DIR + "backup_" + user_id + ".json"
	var data = {}
	if FileAccess.file_exists(backup_path):
		var file = FileAccess.open(backup_path, FileAccess.READ)
		var content = file.get_as_text()
		var parsed_data = JSON.parse_string(content)
		if typeof(parsed_data) == TYPE_DICTIONARY:
			data = parsed_data
		else:
			print("❌ Could not parse backup file.")
	else:
		print("ℹ️ No backup found for user: " + user_id)
	return data

# Load data from backup and merge it into save_state.json if exists
func load_and_merge_backup(user_id: String) -> void:
	var backup_data = load_backup(user_id)
	if backup_data != {}:
		# Merge backup data into save_state.json
		var save_state = {
			"email": backup_data["email"],
			"uid": backup_data["uid"],
			"username": backup_data["username"],
			"id_token": backup_data["id_token"],
			"progress": backup_data["progress"]  # Merging the progress data
		}
		# Write to save_state.json
		var save_file = FileAccess.open("res://SAVES/save_state.json", FileAccess.WRITE_READ)
		if save_file:
			save_file.seek(0)  # Clear file content
			save_file.store_string(JSON.stringify(save_state, "\t"))  # Store merged data
			save_file.close()
			print("✅ Merged backup data into save_state.json")
		else:
			print("❌ Failed to open save_state.json for merging.")
	else:
		print("ℹ️ No backup to merge. Proceeding with new save.")

# Set the flag to skip backup during logout
func start_logout_process() -> void:
	is_logout_in_progress = true
	print("Logout process started. Skipping backup creation.")

# Reset the flag when the logout process is complete
func end_logout_process() -> void:
	is_logout_in_progress = false
	print("Logout process completed. Backup creation allowed again.")
