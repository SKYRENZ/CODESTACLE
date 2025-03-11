extends Node2D

@export var floor_number: int = 1  # Set this for each floor in the Inspector

var timer_manager = null
var timer_ui_scene = preload("res://SCENES/Mechanics/timer.tscn")  # Create this scene
var timer_ui_instance = null

func _ready():
	# Get reference to the timer manager
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	if timer_manager == null:
		printerr("FloorTimerManager not found!")
		return
	
	# Start the timer for this floor
	timer_manager.start_timer(floor_number)
	
	# Instance and add the timer UI
	timer_ui_instance = timer_ui_scene.instantiate()
	add_child(timer_ui_instance)

func _exit_tree():
	# Optional: Stop timer if player exits scene without using the door
	# (e.g., if they quit the game or use a different exit)
	if timer_manager and timer_manager.timer_running and timer_manager.current_floor == floor_number:
		timer_manager.stop_timer()
		timer_manager.save_times()
