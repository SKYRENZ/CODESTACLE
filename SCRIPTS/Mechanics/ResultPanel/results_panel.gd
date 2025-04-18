extends CanvasLayer

signal results_closed

var timer_manager = null
var quiz_data_manager = null

@onready var background_dim: ColorRect = $DimBackground  
@onready var panel: Panel = $"ColorRect/Panel"
@onready var title_label: Label = $"ColorRect/Floor complete label"
@onready var score_label: Label = $"ColorRect/quiz score/quiz percentage"
@onready var time_label: Label = $"ColorRect/floor time/floor time timestamp"
@onready var continue_button: Button = $"ColorRect/Button"
@onready var signs_label: Label = $"ColorRect/Sign/Sign Score"
@onready var npcs_label: Label = $"ColorRect/NPC/NPC Score"
@onready var coins_label: Label = $"ColorRect/Coins/Gathered Coins"

var door_controller = null

func _ready():
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	quiz_data_manager = get_node_or_null("/root/QuizDataManager")

	panel.visible = false
	background_dim.visible = false  

	continue_button.connect("pressed", Callable(self, "_on_continue_pressed"))

func show_results(floor_number: int, quiz_score: int = -1, controller = null):
	door_controller = controller

	if quiz_score == -1 and quiz_data_manager != null:
		quiz_score = calculate_quiz_score(floor_number)

	title_label.text = "Floor " + str(floor_number) + " Complete!"
	var score_percent = quiz_score
	score_label.text = str(score_percent) + "%" if score_percent > 0 else "No Quiz Data Available"

	if timer_manager and timer_manager.current_floor == floor_number:
		var elapsed_time = timer_manager.stop_timer()
		time_label.text = timer_manager.format_time(elapsed_time)
	else:
		time_label.text = "Not available"

	var player_data = get_node_or_null("/root/PlayerData")
	if player_data:
		print("[DEBUG] Fetching Signs Read:", player_data.get_signs_read())  
		print("[DEBUG] Fetching NPCs Engaged:", player_data.get_npcs_engaged())  
		
		signs_label.text = str(player_data.get_signs_read() * 50)  
		npcs_label.text = str(player_data.get_npcs_engaged() * 60)  

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
