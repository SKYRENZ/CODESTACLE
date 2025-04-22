extends CanvasLayer

signal results_closed

var timer_manager = null
var quiz_data_manager = null
var progress_tracker = null  # optional if you use one
var door_controller = null

@onready var background_dim: ColorRect = $DimBackground  
@onready var panel: Panel = $"ColorRect/Panel"
@onready var title_label: Label = $"ColorRect/Floor complete label"
@onready var score_label: Label = $"ColorRect/quiz score/quiz percentage"
@onready var time_label: Label = $"ColorRect/floor time/floor time timestamp"
@onready var continue_button: Button = $"ColorRect/Button"
@onready var signs_label: Label = $"ColorRect/Sign/Sign Score"
@onready var npcs_label: Label = $"ColorRect/NPC/NPC Score"
@onready var coins_label: Label = $"ColorRect/Coins/Gathered Coins"

func _ready():
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	quiz_data_manager = get_node_or_null("/root/QuizDataManager")
	progress_tracker = get_node_or_null("/root/ProgressTracker")  # optional
	continue_button.connect("pressed", Callable(self, "_on_continue_pressed"))

	panel.visible = false
	background_dim.visible = false  

func show_results(floor_number: int, quiz_score: int = -1, controller = null):
	door_controller = controller

	if quiz_score == -1 and quiz_data_manager != null:
		quiz_score = calculate_quiz_score(floor_number)

	title_label.text = "Floor " + str(floor_number) + " Complete!"
	var score_percent = quiz_score
	score_label.text = str(score_percent) + "%" if score_percent > 0 else "No Quiz Data Available"

	var elapsed_time = 0.0
	if timer_manager and timer_manager.current_floor == floor_number:
		elapsed_time = timer_manager.stop_timer()
		time_label.text = timer_manager.format_time(elapsed_time)
	else:
		time_label.text = "Not available"

	var player_data = get_node_or_null("/root/PlayerData")
	var signs = 0
	var npcs = 0
	var coins = 0

	if player_data:
		signs = player_data.get_signs_read()
		npcs = player_data.get_npcs_engaged()
		if player_data.has_method("get_coins_collected"):
			coins = player_data.get_coins_collected()

		signs_label.text = str(signs * 50)
		npcs_label.text = str(npcs * 60)
		coins_label.text = str(coins)

	# ✅ Save floor progress to UserDataManager (local)
	var floor_key = "floor_" + str(floor_number)
	var floor_data = {
		"time": elapsed_time,
		"quiz_score": quiz_score,
		"signages": signs,
		"npcs": npcs,
		"coins": coins
	}

	var user_data = UserDataManager.load_local_user_data()
	if typeof(user_data) == TYPE_DICTIONARY:
		if not user_data.has("progress"):
			user_data["progress"] = {}
		user_data["progress"][floor_key] = floor_data

		UserDataManager.save_user_data_locally(
			user_data.get("email", ""),
			user_data.get("uid", ""),
			user_data.get("username", ""),
			user_data.get("id_token", ""),
			user_data["progress"]
		)
		print("✅ Floor data saved to user profile locally.")

		# ✅ Save to Firestore
		FirestoreManager.save_user_data_to_firestore(
			user_data.get("email", ""),
			user_data.get("uid", ""),
			user_data.get("username", ""),
			user_data.get("id_token", ""),
			user_data["progress"]
		)
		print("✅ Floor data saved to Firestore.")
	else:
		print("❌ Failed to load user data, progress not saved.")

	panel.visible = true
	background_dim.visible = true
	get_tree().paused = true  

	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0 and player[0].has_method("set_movement_locked"):
		player[0].set_movement_locked(true)

	if player_data:
		player_data.reset_floor_data()

func calculate_quiz_score(floor_number: int) -> int:
	return randi_range(50, 100)

func _on_continue_pressed():
	print("Continue button pressed!")
	get_tree().paused = false

	if door_controller and door_controller.has_method("transition_to_next_floor"):
		door_controller.transition_to_next_floor()
	else:
		print("Door controller reference not valid!")

	panel.visible = false
	background_dim.visible = false  
	queue_free()
