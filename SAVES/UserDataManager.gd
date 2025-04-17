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

# Reset user data to empty structure
func reset_user_data() -> void:
	var default_save_data = {
		"email": "",
		"uid": "",
		"username": "",
		"id_token": "",
		"progress": {}
	}

	var file = FileAccess.open(local_storage_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(default_save_data, "\t"))
		file.close()
		print("✅ User data reset.")
	else:
		print("❌ Could not reset user data.")
