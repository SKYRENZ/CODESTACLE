extends Node

# Path to save user data locally
var local_storage_path = "res://SAVES/save_state.json"

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
		file.truncate()  # ✅ Prevent corruption by clearing file first
		var json_string = JSON.stringify(json_data, "\t")
		file.store_string(json_string)
		file.close()
		print("✅ User data saved locally.")

		# Use BackupSave autoload to store a backup file
		BackupSave.create_backup_save(email, user_id, username, id_token, progress)
	else:
		print("❌ Could not save user data locally.")

# Load local user data
func load_local_user_data() -> Dictionary:
	if FileAccess.file_exists(local_storage_path):
		var file = FileAccess.open(local_storage_path, FileAccess.READ)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if typeof(data) == TYPE_DICTIONARY:
			return data
		else:
			print("❌ Could not parse local user data.")
	else:
		print("ℹ️ No local user data found.")
	return {}

# Reset user data to empty structure, but keep other user information intact
func reset_user_data() -> void:
	# Declare the SAVE_DIR constant here if it's not defined globally
	const SAVE_DIR := "res://SAVES/"

	if FileAccess.file_exists(local_storage_path):
		var file = FileAccess.open(local_storage_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()

		var data = JSON.parse_string(content)
		if typeof(data) == TYPE_DICTIONARY:
			data["progress"] = {}  # Wipe only the progress

			var write_file = FileAccess.open(local_storage_path, FileAccess.WRITE)
			if write_file:
				write_file.store_string(JSON.stringify(data, "\t"))
				write_file.close()
				print("✅ User data reset, progress wiped.")
				
				# Check if backup exists for the user based on their UID
				var backup_path = SAVE_DIR + "backup_" + data["uid"] + ".json"
				if FileAccess.file_exists(backup_path):
					print("ℹ️ Backup file already exists for user: " + data["uid"])
					# Update the backup with the latest data (including the reset progress)
					BackupSave.create_backup_save(data["email"], data["uid"], data["username"], data["id_token"], data["progress"])
				else:
					print("ℹ️ No existing backup file found, creating a new one.")
					# Create a new backup file if it doesn't exist
					BackupSave.create_backup_save(data["email"], data["uid"], data["username"], data["id_token"], data["progress"])

			else:
				print("❌ Could not reopen file for writing.")
		else:
			print("❌ Failed to parse the save file!")
	else:
		print("❌ Save file not found!")



# Retrieve the latest user data (for use in FirestoreManager)
func get_latest_user_data() -> Dictionary:
	return load_local_user_data()

# Set the ID token and save it to local user data
func set_id_token(token: String) -> void:
	var data = load_local_user_data()
	data["id_token"] = token
	save_user_data_locally(data["email"], data["uid"], data["username"], token, data["progress"])
	print("🔐 ID Token set and saved locally.")
