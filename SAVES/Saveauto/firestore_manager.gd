extends Node

signal user_data_saved
signal user_data_save_failed
signal user_data_fetched
signal user_data_fetch_failed

var project_id = "codestacle-cd97a"  # Replace with your actual Firebase project ID
var id_token = ""  # Store the ID token for authentication

@onready var http_request = HTTPRequest.new()

# Save full user data including progress to Firestore
func save_user_data_to_firestore(email: String, user_id: String, username: String, id_token_param: String, progress: Dictionary) -> void:
	# Ensure the ID token is valid
	if id_token_param == "":
		print("❌ ID token is empty or invalid!")
		emit_signal("user_data_save_failed")
		return
	
	id_token = id_token_param  # Set the ID token

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
	http_request.request_completed.connect(_on_request_completed_save.bind("save"))

	var headers = ["Content-Type: application/json", "Authorization: Bearer " + id_token]
	var body = JSON.stringify(firestore_data)

	var error = http_request.request(firestore_url, headers, HTTPClient.METHOD_PATCH, body)
	if error != OK:
		print("❌ Error sending request:", error)
	else:
		print("[Firestore] Uploading user data to Firestore...")

# HTTP response handler for saving user data
func _on_request_completed_save(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, operation: String) -> void:
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

# Fetch user data from Firestore and save it locally
func fetch_user_data_from_firestore(user_id: String) -> void:
	# Ensure the ID token is valid
	if id_token == "":
		print("❌ ID token is empty or invalid!")
		emit_signal("user_data_fetch_failed")
		return
	
	# URL to fetch user data from Firestore
	var firestore_url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/users/%s" % [project_id, user_id]

	# Add the HTTPRequest node to the scene
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed_fetch.bind("fetch", user_id))

	# Set the headers and send the request
	var headers = ["Content-Type: application/json", "Authorization: Bearer " + id_token]
	var error = http_request.request(firestore_url, headers)
	if error != OK:
		print("❌ Error sending request:", error)
	else:
		print("[Firestore] Fetching user data from Firestore...")

# HTTP response handler for fetching user data
func _on_request_completed_fetch(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, operation: String, user_id: String) -> void:
	if response_code == 200:
		print("[Firestore] ✅ User data fetched successfully.")
		# Create an instance of JSON to parse the response body
		var json_instance = JSON.new()
		var response_data = json_instance.parse(body.get_string_from_utf8())
		
		if response_data != OK:
			print("❌ Error parsing Firestore response.")
			emit_signal("user_data_fetch_failed")
			return
		
		# Translate Firestore data to the local save format
		var user_data = translate_firestore_data_to_local(response_data.result)
		# Save the translated data locally
		save_local_data(user_data)
		emit_signal("user_data_fetched")
	else:
		print("[Firestore] ❌ Error fetching user data. Response Code: %d" % response_code)
		print("🔥 Response Body:", body.get_string_from_utf8())
		emit_signal("user_data_fetch_failed")

# Translate Firestore data format to local save format
func translate_firestore_data_to_local(firestore_data: Dictionary) -> Dictionary:
	var local_data = {}
	
	# Translate the fields from Firestore format to your local format
	local_data["email"] = firestore_data["fields"]["email"]["stringValue"]
	local_data["user_id"] = firestore_data["fields"]["user_id"]["stringValue"]
	local_data["username"] = firestore_data["fields"]["username"]["stringValue"]
	
	# Translate progress (assuming progress is a map in Firestore)
	var progress = firestore_data["fields"]["progress"]["mapValue"]["fields"]
	local_data["progress"] = {}
	
	local_data["progress"]["coins"] = progress["coins"]["integerValue"]
	local_data["progress"]["npcs"] = progress["npcs"]["integerValue"]
	local_data["progress"]["signages"] = progress["signages"]["integerValue"]
	local_data["progress"]["time"] = progress["time"]["doubleValue"]
	
	return local_data

# Save user data locally (example: using JSON files)
func save_local_data(user_data: Dictionary) -> void:
	var save_path = "res://SAVES/save_state.json"
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file != null:
		file.store_string(JSON.stringify(user_data))
		file.close()
		print("[Local Save] ✅ User data saved locally.")
	else:
		print("[Local Save] ❌ Error saving user data locally.")
