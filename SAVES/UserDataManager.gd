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
	if not dir.dir_exists("SAVES"):
		dir.make_dir("SAVES")

	var file = FileAccess.open(local_storage_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(json_data, "\t"))
		file.close()
		print("✅ User data saved locally.")
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
	# Check if save file exists
	if FileAccess.file_exists(local_storage_path):
		var file = FileAccess.open(local_storage_path, FileAccess.READ_WRITE)
		var json_instance = JSON.new()  # Create an instance of the JSON class
		var save_data = json_instance.parse(file.get_as_text())
		if save_data == OK:
			var user_data = json_instance.get_data()
			# Reset progress but keep email, uid, username, id_token intact
			user_data["progress"] = {}  # Reset progress only
			# Save the updated data back to the file
			file.seek(0)
			file.store_string(json_instance.print(user_data, "\t"))
			file.close()
			print("✅ User data reset, progress wiped.")
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
	data["id_token"] = token  # Update the stored token
	save_user_data_locally(data["email"], data["uid"], data["username"], token, data["progress"])
	print("🔐 ID Token set and saved locally.")
