extends CanvasLayer

@onready var username_labels = [
	$Username/UN1, $Username/UN2, $Username/UN3, $Username/UN4, $Username/UN5,
	$Username/UN6, $Username/UN7, $Username/UN8, $Username/UN9, $Username/UN10
]

@onready var score_labels = [
	$HighestScore/HS1, $HighestScore/HS2, $HighestScore/HS3, $HighestScore/HS4, $HighestScore/HS5,
	$HighestScore/HS6, $HighestScore/HS7, $HighestScore/HS8, $HighestScore/HS9, $HighestScore/HS10
]

@onready var time_labels = [
	$ShortestTime/ST1, $ShortestTime/ST2, $ShortestTime/ST3, $ShortestTime/ST4, $ShortestTime/ST5,
	$ShortestTime/ST6, $ShortestTime/ST7, $ShortestTime/ST8, $ShortestTime/ST9, $ShortestTime/ST10
]

func _ready():
	# Connect to signal to wait for successful fetch
	LeaderboardManager.leaderboard_fetch_success.connect(_on_leaderboard_success)
	LeaderboardManager.leaderboard_fetch_failed.connect(_on_leaderboard_fail)

	# Call the correct fetch function
	LeaderboardManager.fetch_leaderboard_from_firestore()

func _on_leaderboard_success():
	var entries = LeaderboardManager.leaderboard_entries.duplicate()
	entries.sort_custom(func(a, b): return a["overall_score"] > b["overall_score"]) # Sort descending

	for i in range(10):
		if i < entries.size():
			var entry = entries[i]
			var username = entry.get("username", "N/A")
			var score = entry.get("overall_score", 0)
			var shortest_time = entry.get("shortest_time", "N/A")

			username_labels[i].text = username
			score_labels[i].text = str(score)

			# Format the shortest_time to show only two digits if it's a float
			if shortest_time is float:
				# Format the float to two decimal places
				shortest_time = String("%.2f" % shortest_time)
			elif shortest_time == "N/A":
				shortest_time = "N/A"

			# Update the time label with the formatted shortest_time value
			time_labels[i].text = str(shortest_time)  # Use shortest_time instead of best_time
		else:
			username_labels[i].text = "-"
			score_labels[i].text = "-"
			time_labels[i].text = "-"

func _on_leaderboard_fail():
	print("⚠️ Failed to load leaderboard. Please check Firestore or network connection.")

func _on_Exit_pressed() ->void:
	queue_free()


func _on_exit_pressed() -> void:
	pass # Replace with function body.
