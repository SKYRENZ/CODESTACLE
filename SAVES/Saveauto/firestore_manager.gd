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
	if id_token_param == "":
		print("❌ ID token is empty or invalid!")
		emit_signal("user_data_save_failed")
		return

	id_token = id_token_param

	var data = {
		"email": email,
		"user_id": user_id,
		"username": username,
		"progress": progress
	}

	print("🔍 Saving user data to Firestore with progress:")
	print(progress)

	var firestore_data = { "fields": {} }
	for key in data.keys():
		firestore_data["fields"][key] = convert_to_firestore_format(data[key])

	print("📦 Final Firestore JSON:")
	print(JSON.stringify(firestore_data, "\t"))

	var firestore_url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/users/%s" % [project_id, user_id]

	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed_save.bind("save"))

	var headers = ["Content-Type: application/json", "Authorization: Bearer " + id_token]
	var body = JSON.stringify(firestore_data)

	var error = http_request.request(firestore_url, headers, HTTPClient.METHOD_PATCH, body)
	if error != OK:
		print("❌ Error sending request:", error)
	else:
		print("[Firestore] Uploading user data to Firestore...")

func _on_request_completed_save(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, operation: String) -> void:
	if response_code == 200:
		print("[Firestore] ✅ User data saved successfully.")
		emit_signal("user_data_saved")
	else:
		print("[Firestore] ❌ Error saving user data. Response Code: %d" % response_code)
		print("🔥 Response Body:", body.get_string_from_utf8())
		emit_signal("user_data_save_failed")

func convert_to_firestore_format(value):
	match typeof(value):
		TYPE_STRING:
			return { "stringValue": value }
		TYPE_INT:
			return { "integerValue": str(value) }
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

func set_id_token(token: String) -> void:
	id_token = token
	print("🔐 ID Token set successfully.")

func fetch_user_data_from_firestore(user_id: String) -> void:
	if id_token == "":
		print("❌ ID token is empty or invalid!")
		emit_signal("user_data_fetch_failed")
		return

	var firestore_url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/users/%s" % [project_id, user_id]

	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed_fetch.bind("fetch", user_id))

	var headers = ["Content-Type: application/json", "Authorization: Bearer " + id_token]
	var error = http_request.request(firestore_url, headers)
	if error != OK:
		print("❌ Error sending request:", error)
	else:
		print("[Firestore] Fetching user data from Firestore...")

func _on_request_completed_fetch(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, operation: String, user_id: String) -> void:
	if response_code == 200:
		print("[Firestore] ✅ User data fetched successfully.")
		var json_instance = JSON.new()
		var response_data = json_instance.parse(body.get_string_from_utf8())

		if response_data != OK:
			print("❌ Error parsing Firestore response.")
			emit_signal("user_data_fetch_failed")
			return

		var user_data = translate_firestore_data_to_local(response_data.result)
		save_local_data(user_data)
		emit_signal("user_data_fetched")
	else:
		print("[Firestore] ❌ Error fetching user data. Response Code: %d" % response_code)
		print("🔥 Response Body:", body.get_string_from_utf8())
		emit_signal("user_data_fetch_failed")

func translate_firestore_data_to_local(firestore_data: Dictionary) -> Dictionary:
	var local_data = {}
	local_data["email"] = firestore_data["fields"]["email"]["stringValue"]
	local_data["user_id"] = firestore_data["fields"]["user_id"]["stringValue"]
	local_data["username"] = firestore_data["fields"]["username"]["stringValue"]

	var progress = firestore_data["fields"]["progress"]["mapValue"]["fields"]
	local_data["progress"] = {}
	local_data["progress"]["coins"] = progress["coins"]["integerValue"]
	local_data["progress"]["npcs"] = progress["npcs"]["integerValue"]
	local_data["progress"]["signages"] = progress["signages"]["integerValue"]
	local_data["progress"]["time"] = progress["time"]["doubleValue"]

	return local_data

func save_local_data(user_data: Dictionary) -> void:
	var save_path = "res://SAVES/save_state.json"
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file != null:
		file.store_string(JSON.stringify(user_data))
		file.close()
		print("[Local Save] ✅ User data saved locally.")
	else:
		print("[Local Save] ❌ Error saving user data locally.")

# 🔥 NEW: Fetch all users for leaderboard
func fetch_all_users_for_leaderboard() -> void:
	if id_token == "":
		print("❌ ID token is empty or invalid!")
		return

	var url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/users" % project_id
	var headers = ["Authorization: Bearer " + id_token]

	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed_leaderboard)
	var error = http_request.request(url, headers)
	if error != OK:
		print("❌ Error sending leaderboard request:", error)

func _on_request_completed_leaderboard(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	http_request.request_completed.disconnect(_on_request_completed_leaderboard)

	if response_code == 200:
		var json = JSON.new()
		if json.parse(body.get_string_from_utf8()) == OK:
			var result_data = json.get_data()
			var leaderboard_data := []

			for document in result_data["documents"]:
				var fields = document.get("fields", {})
				var username = fields.get("username", {}).get("stringValue", "")
				var progress = fields.get("progress", {}).get("mapValue", {}).get("fields", {})

				var overall_score = progress.get("overall_score", {}).get("integerValue", "0").to_int()
				var time = progress.get("time", {}).get("doubleValue", "0.0").to_float()

				leaderboard_data.append({
					"username": username,
					"overall_score": overall_score,
					"time": time
				})

			LeaderboardManager.set_leaderboard_entries(leaderboard_data)
			print("[Firestore] ✅ Leaderboard data fetched and passed to LeaderboardManager.")
		else:
			print("❌ Failed to parse leaderboard response.")
	else:
		print("❌ Leaderboard fetch failed. Code: %d" % response_code)
		print(body.get_string_from_utf8())
