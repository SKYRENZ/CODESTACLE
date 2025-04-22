extends Node

# Store quiz scores and interaction stats
var quiz_scores = {}
var signs_read = 0
var npcs_engaged = 0

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

func get_signs_read():
	return signs_read

func get_npcs_engaged():
	return npcs_engaged

# Reset data when a new floor starts
func reset_floor_data():
	signs_read = 0
	npcs_engaged = 0
	print("[DEBUG] Resetting floor data!")  # Debug print

# Clear all stored scores (useful for restarting the game)
func reset_all_data():
	quiz_scores.clear()
	reset_floor_data()

# Save current player data to UserDataManager
func save_to_user_data(floor_number: int, quiz_score: int) -> void:
	# Fetch current user data from UserDataManager (Autoload)
	var user_data = UserDataManager.load_local_user_data()

	if typeof(user_data) == TYPE_DICTIONARY:
		# Prepare floor data to be stored in the progress dictionary
		var floor_key = "floor_" + str(floor_number)
		var floor_data = {
			"time": 0,  # This will be updated later, after you fetch the time from the timer
			"quiz_score": quiz_score,
			"signages": signs_read,
			"npcs": npcs_engaged,
			"coins": 0  # You can pass coins here if necessary
		}

		# Add the floor data to the progress
		if not user_data.has("progress"):
			user_data["progress"] = {}
		user_data["progress"][floor_key] = floor_data

		# Save the updated user data locally via UserDataManager (Autoload)
		UserDataManager.save_user_data_locally(
			user_data.get("email", ""),
			user_data.get("uid", ""),
			user_data.get("username", ""),
			user_data.get("id_token", ""),
			user_data["progress"]
		)

		# Now save the updated data to Firestore via FirestoreManager (Autoload)
		FirestoreManager.save_user_data_to_firestore(
			user_data.get("email", ""),
			user_data.get("uid", ""),
			user_data.get("username", ""),
			user_data.get("id_token", ""),
			user_data["progress"]
		)

		print("✅ Player data for floor", floor_number, "saved to Firestore and local profile.")
	else:
		print("❌ Failed to load user data, unable to save.")
