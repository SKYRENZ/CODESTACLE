extends Node

# Store quiz scores and interaction stats
var quiz_scores = {}
var signs_read = 0
var npcs_engaged = 0
var coins_collected = 0  # New variable to track coins

# Add or update a quiz score
func set_quiz_score(floor_number: int, score: int, total_questions: int) -> void:
	var percentage = 0
	if total_questions > 0:
		percentage = int((float(score) / float(total_questions)) * 100)
	
	quiz_scores[floor_number] = percentage
	print("Set quiz score for floor ", floor_number, ": ", percentage, "%")

# Get quiz score for a specific floor
func get_quiz_score(floor_num: int) -> int:
	return quiz_scores.get(floor_num, 0)

# Track interactions
func increment_signs_read():
	signs_read += 1

func increment_npcs_engaged():
	npcs_engaged += 1
	print("[DEBUG] Incremented NPCs Engaged:", npcs_engaged)  # Debug print

func increment_coins_collected(amount: int = 1):
	coins_collected += amount
	print("[DEBUG] Incremented Coins Collected:", coins_collected)  # Debug print

func get_signs_read():
	return signs_read

func get_npcs_engaged():
	return npcs_engaged

func get_coins_collected():
	return coins_collected

# Reset data when a new floor starts
func reset_floor_data():
	signs_read = 0
	npcs_engaged = 0
	coins_collected = 0
	print("[DEBUG] Resetting floor data!")  # Debug print

# Clear all stored scores (useful for restarting the game)
func reset_all_data():
	quiz_scores.clear()
	reset_floor_data()
