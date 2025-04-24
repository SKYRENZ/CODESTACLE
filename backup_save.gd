extends Node

# Directory where all backup files are stored
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
		file.truncate()  # ✅ Clear old content
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("✅ Backup created for user: " + user_id)
	else:
		print("❌ Failed to create backup for user.")

# Load backup for a specific user by UID
func load_backup(user_id: String) -> Dictionary:
	var backup_path = SAVE_DIR + "backup_" + user_id + ".json"
	if FileAccess.file_exists(backup_path):
		var file = FileAccess.open(backup_path, FileAccess.READ)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if typeof(data) == TYPE_DICTIONARY:
			return data
		else:
			print("❌ Could not parse backup file.")
	else:
		print("ℹ️ No backup found for user: " + user_id)
	return {}

# Set the flag to skip backup during logout
func start_logout_process() -> void:
	is_logout_in_progress = true
	print("Logout process started. Skipping backup creation.")

# Reset the flag when the logout process is complete
func end_logout_process() -> void:
	is_logout_in_progress = false
	print("Logout process completed. Backup creation allowed again.")
