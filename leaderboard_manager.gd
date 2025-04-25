extends Node

signal leaderboard_updated
signal leaderboard_fetch_success
signal leaderboard_fetch_failed

# Store leaderboard data
var leaderboard_entries: Array = []  # List of leaderboard entries

# Firebase Info
var project_id: String = "codestacle-cd97a"
@onready var http_request = HTTPRequest.new()

func _ready():
	# Proceed to fetch the leaderboard without authentication
	fetch_leaderboard_from_firestore()

# Fetch leaderboard data from Firestore
func fetch_leaderboard_from_firestore() -> void:
	var url = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/users?pageSize=50" % project_id

	add_child(http_request)
	http_request.request_completed.connect(_on_leaderboard_fetch_complete)

	var headers = ["Content-Type: application/json"]
	var error = http_request.request(url, headers)

	if error != OK:
		print("❌ Error sending leaderboard fetch request: ", error)
	else:
		print("[Firestore] 📡 Fetching leaderboard entries...")

func _on_leaderboard_fetch_complete(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json = JSON.new()
		var parsed = json.parse(body.get_string_from_utf8())

		if parsed != OK:
			print("❌ Failed to parse leaderboard data.")
			emit_signal("leaderboard_fetch_failed")
			return

		var response_data = json.get_data()  # Get parsed response data
		var documents = response_data.get("documents", [])
		leaderboard_entries.clear()

		# Initialize a dictionary to store the best scores and times for each floor
		var floor_data = {
			"floor_1": {"best_score": 0, "best_time": "N/A", "best_username": ""},
			"floor_2": {"best_score": 0, "best_time": "N/A", "best_username": ""},
			"floor_3": {"best_score": 0, "best_time": "N/A", "best_username": ""},
			"floor_4": {"best_score": 0, "best_time": "N/A", "best_username": ""},
			"floor_5": {"best_score": 0, "best_time": "N/A", "best_username": ""}
		}

		# Loop through each document to extract the best score and time for each floor
		for doc in documents:
			var fields = doc.get("fields", {})
			var username = fields.get("username", {}).get("stringValue", "unknown")

			# Access the progress and floor data
			var progress = fields.get("progress", {}).get("mapValue", {}).get("fields", {})
			var floors = ["floor_1", "floor_2", "floor_3", "floor_4", "floor_5"]

			for floor in floors:
				var floor_data_fields = progress.get(floor, {}).get("mapValue", {}).get("fields", {})
				var score = int(floor_data_fields.get("overall_score", {}).get("integerValue", "0"))
				var time = float(floor_data_fields.get("time", {}).get("doubleValue", "0.0"))

				# If the score is better than the current best score or time
				if score > floor_data[floor]["best_score"]:
					floor_data[floor]["best_score"] = score
					floor_data[floor]["best_time"] = time if time != 0.0 else "N/A"
					floor_data[floor]["best_username"] = username

		# Now add the best floor data for each floor to the leaderboard_entries
		for floor in floor_data.keys():
			leaderboard_entries.append({
				"username": floor_data[floor]["best_username"],
				"overall_score": floor_data[floor]["best_score"],
				"shortest_time": floor_data[floor]["best_time"]
			})

		print("[Firestore] ✅ Leaderboard fetched. Entries: %d" % leaderboard_entries.size())
		emit_signal("leaderboard_fetch_success")
	else:
		print("[Firestore] ❌ Failed to fetch leaderboard. Code: %d" % response_code)
		emit_signal("leaderboard_fetch_failed")
