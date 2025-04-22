extends CanvasLayer

signal results_closed

var timer_manager = null
var quiz_data_manager = null
var progress_tracker = null  # optional if you use one
var door_controller = null
var objective_manager = null  # Reference to ObjectiveManager

@onready var background_dim: ColorRect = $DimBackground  
@onready var panel: Panel = $"ColorRect/Panel"
@onready var title_label: Label = $"ColorRect/Floor complete label"
@onready var score_label: Label = $"ColorRect/quiz score/quiz percentage"
@onready var time_label: Label = $"ColorRect/floor time/floor time timestamp"
@onready var continue_button: Button = $"ColorRect/Button"
@onready var signs_label: Label = $"ColorRect/Sign/Sign Score"
@onready var npcs_label: Label = $"ColorRect/NPC/NPC Score"
@onready var coins_label: Label = $"ColorRect/Coins/Gathered Coins"
@onready var total_score_label: Label = $"ColorRect/Total/total Score"  # Updated path for total score label
@onready var star1: Sprite2D = $Star1  # Updated to Sprite2D
@onready var star2: Sprite2D = $Star2  # Updated to Sprite2D
@onready var star3: Sprite2D = $Star3  # Updated to Sprite2D

var player_data = null  # To store the reference to PlayerData

func _ready():
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	quiz_data_manager = get_node_or_null("/root/QuizDataManager")
	progress_tracker = get_node_or_null("/root/ProgressTracker")  # optional
	objective_manager = get_node_or_null("/root/ObjectiveManager")  # Fetch ObjectiveManager
	continue_button.connect("pressed", Callable(self, "_on_continue_pressed"))
	
	player_data = get_node_or_null("/root/PlayerData")  # Fetch the PlayerData node
	
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

	# Fetch and display player data (signs, NPCs, and coins)
	var signs = 0
	var npcs = 0
	var coins = 0

	if objective_manager:
		signs = objective_manager.current_read
		npcs = objective_manager.current_npcs_interacted

	if player_data:
		coins = player_data.get_coins_collected()

	# Calculate points
	var sign_points = signs * 40
	var npc_points = npcs * 40
	var coin_points = coins * 5

	# Calculate quiz points (50 points for 100%, scaled down for lower percentages)
	var quiz_points = int((score_percent / 100.0) * 50)

	# Calculate time points
	var time_points = 0
	if elapsed_time < 30:
		time_points = 80
	else:
		time_points = 50

	# Calculate total score
	var total_score = sign_points + npc_points + coin_points + quiz_points + time_points

	# Update UI labels with the player data
	signs_label.text = "%d" % sign_points
	npcs_label.text = "%d" % npc_points
	coins_label.text = "%d" % coin_points
	total_score_label.text = "%d" % total_score  # Update total score label

	# Determine star rating (adjusted for testing)
	var stars = 0
	if total_score >= 300:
		stars = 3
	elif total_score >= 200:
		stars = 2
	else:
		stars = 1

	# Update star visibility
	star1.visible = stars >= 1
	star2.visible = stars >= 2
	star3.visible = stars >= 3

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
