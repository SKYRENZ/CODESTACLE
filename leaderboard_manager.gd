extends Node

# Store leaderboard data
var leaderboard = {}

# This signal will be emitted when the leaderboard is updated
signal leaderboard_updated

# Initialize the leaderboard with default values
func _ready():
	# Initialize with empty data for each floor
	leaderboard["overall_score"] = 0
	leaderboard["floor_times"] = {}

# Function to set the overall score
func set_overall_score(score: int) -> void:
	leaderboard["overall_score"] = score
	emit_signal("leaderboard_updated")

# Function to set the time for a floor
func set_floor_time(floor_number: int, time_seconds: float) -> void:
	leaderboard["floor_times"][floor_number] = time_seconds
	emit_signal("leaderboard_updated")

# Function to fetch the overall score
func get_overall_score() -> int:
	return leaderboard["overall_score"]

# Function to fetch the time for a floor
func get_floor_time(floor_number: int) -> float:
	return leaderboard["floor_times"].get(floor_number, -1)  # Default -1 if not set

# Save leaderboard data locally (optional)
func save_leaderboard_data() -> void:
	var save_path = "res://SAVES/leaderboard_data.json"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(leaderboard))
		file.close()
		print("[Leaderboard] ✅ Data saved locally.")
	else:
		print("[Leaderboard] ❌ Error saving leaderboard data locally.")

# Load leaderboard data locally (optional)
func load_leaderboard_data() -> void:
	var save_path = "res://SAVES/leaderboard_data.json"
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		# Create an instance of JSON
		var json_instance = JSON.new()
		var loaded_data = json_instance.parse(json_data)
		if loaded_data.error == OK:
			leaderboard = loaded_data.result
			print("[Leaderboard] ✅ Data loaded.")
		else:
			print("[Leaderboard] ❌ Error parsing leaderboard data.")
		file.close()
