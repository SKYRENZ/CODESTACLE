extends Node

# Declare signals for when user data is saved or failed
signal user_data_saved
signal user_data_save_failed

# Preload the Firestore script
var Firestore = preload("res://addons/godot-firebase/firestore/firestore.gd")
var project_id = "codestacle-cd97a"  # Replace with your actual Firebase project ID

# Firebase Authentication ID token (you should set this after user login)
var id_token = ""  # Empty for now, should be populated after user authentication

# Function to save user data to Firestore
func save_user_data_to_firestore(email: String, user_id: String, username: String, id_token: String) -> void:
	# Prepare the data to save to Firestore
	var data = {
		"email": email,
		"user_id": user_id,
		"username": username
	}

	# Convert the data to Firestore format
	var firestore_data = { "fields": {} }
	for key in data.keys():
		firestore_data["fields"][key] = convert_to_firestore_format(data[key])

	# Firestore URL (users collection)
	var firestore_url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/users/%s" % [project_id, user_id]

	# Send request to Firestore
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed.bind("save"))

	# Ensure id_token is available, set it if not already
	if id_token == "":
		print("❌ ID token is missing. Please authenticate the user first.")
		emit_signal("user_data_save_failed")
		return
	
	var headers = ["Content-Type: application/json", "Authorization: Bearer " + id_token]
	var body = JSON.stringify(firestore_data)

	var error = http_request.request(firestore_url, headers, HTTPClient.METHOD_PATCH, body)
	if error != OK:
		print("❌ Error sending request:", error)
	else:
		print("[Firestore] Uploading user data to Firestore...")

# Handle HTTP request completion
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, operation: String) -> void:
	if response_code == 200:
		print("[Firestore] User data saved successfully.")
		emit_signal("user_data_saved")
	else:
		print("[Firestore] Error saving user data. Response Code: %d" % response_code)
		emit_signal("user_data_save_failed")  # Emit the signal when save fails

# Convert standard values to Firestore format
func convert_to_firestore_format(value):
	if typeof(value) == TYPE_STRING:
		return { "stringValue": value }
	elif typeof(value) == TYPE_INT:
		return { "integerValue": value }
	elif typeof(value) == TYPE_FLOAT:
		return { "doubleValue": value }
	elif typeof(value) == TYPE_BOOL:
		return { "booleanValue": value }
	elif typeof(value) == TYPE_ARRAY:
		var array_values = []
		for item in value:
			array_values.append(convert_to_firestore_format(item))
		return { "arrayValue": { "values": array_values } }
	elif typeof(value) == TYPE_DICTIONARY:
		var map_values = {}
		for k in value.keys():
			map_values[k] = convert_to_firestore_format(value[k])
		return { "mapValue": { "fields": map_values } }
	return { "nullValue": null }

# Example function to simulate setting the ID token after Firebase Authentication (you will replace this with actual Firebase authentication code)
func set_id_token(token: String) -> void:
	id_token = token
	print("ID Token set successfully.")
