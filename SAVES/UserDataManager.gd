extends Node

# Path to save user data locally
var local_storage_path = "res://SAVES/save_state.json"

# Save user data locally
func save_user_data_locally(email: String, user_id: String, username: String, id_token: String) -> void:
	var json_data = {
		"email": email,
		"uid": user_id,
		"username": username,
		"id_token": id_token  # Save the id_token in local storage
	}

	# Ensure the directory exists before saving
	var dir = DirAccess.open("res://SAVES/")
	if not dir.dir_exists("SAVES"):
		dir.make_dir("SAVES")

	var file = FileAccess.open(local_storage_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(json_data, "\t"))
		file.close()
		print("✅ User data saved locally.")
	else:
		print("❌ Error: Could not save user data locally.")

# Load local user data
func load_local_user_data() -> Dictionary:
	var file = FileAccess.open(local_storage_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if typeof(data) == TYPE_DICTIONARY:
			return data
		else:
			print("❌ Error: Could not parse local user data.")
	else:
		print("ℹ️ No local user data found.")
	return {}
