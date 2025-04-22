extends Node

signal user_data_saved
signal user_data_save_failed

var Firestore = preload("res://addons/godot-firebase/firestore/firestore.gd")
var project_id = "codestacle-cd97a"  # Replace with your actual Firebase project ID
var id_token = ""  # Store the ID token for authentication

@onready var http_request = HTTPRequest.new()

# Save full user data including progress to Firestore
func save_user_data_to_firestore(email: String, user_id: String, username: String, id_token: String, progress: Dictionary) -> void:
	var data = {
		"email": email,
		"user_id": user_id,
		"username": username,
		"progress": progress
	}

	# Log for debugging
	print("🔍 Saving user data to Firestore with progress:")
	print(progress)

	var firestore_data = { "fields": {} }
	for key in data.keys():
		firestore_data["fields"][key] = convert_to_firestore_format(data[key])

	# Optional debug log before sending
	print("📦 Final Firestore JSON:")
	print(JSON.stringify(firestore_data, "\t"))

	var firestore_url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/users/%s" % [project_id, user_id]

	# HTTP Request to Firestore
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed.bind("save"))

	if id_token == "":
		print("❌ ID token missing. Please authenticate.")
		emit_signal("user_data_save_failed")
		return

	var headers = ["Content-Type: application/json", "Authorization: Bearer " + id_token]
	var body = JSON.stringify(firestore_data)

	var error = http_request.request(firestore_url, headers, HTTPClient.METHOD_PATCH, body)
	if error != OK:
		print("❌ Error sending request:", error)
	else:
		print("[Firestore] Uploading user data to Firestore...")

# HTTP response handler
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, operation: String) -> void:
	if response_code == 200:
		print("[Firestore] ✅ User data saved successfully.")
		emit_signal("user_data_saved")
	else:
		print("[Firestore] ❌ Error saving user data. Response Code: %d" % response_code)
		print("🔥 Response Body:", body.get_string_from_utf8())
		emit_signal("user_data_save_failed")

# Firestore formatting
func convert_to_firestore_format(value):
	match typeof(value):
		TYPE_STRING:
			return { "stringValue": value }
		TYPE_INT:
			return { "integerValue": str(value) }  # Firestore expects string integers
		TYPE_FLOAT:
			return { "doubleValue": value }
		TYPE_BOOL:
			return { "booleanValue": value }
		TYPE_ARRAY:
			var array_values = []
			for item in value:
				array_values.append(convert_to_firestore_format(item))
			return { "arrayValue": { "values": array_values } }
		TYPE_DICTIONARY:
			var map_fields = {}
			for key in value.keys():
				map_fields[key] = convert_to_firestore_format(value[key])
			return { "mapValue": { "fields": map_fields } }
		_:
			return { "nullValue": null }

# Set ID token after login
func set_id_token(token: String) -> void:
	id_token = token
	print("🔐 ID Token set successfully.")
