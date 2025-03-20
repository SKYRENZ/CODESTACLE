extends Node2D

@export var floor_number: int = 0  # Set this for each floor in the Inspector
@export var signage_count: int = 0
var timer_manager = null
var timer_ui_scene = preload("res://SCENES/Mechanics/HUD/Timer/timer.tscn")
const ObjectivesScene = preload("res://SCENES/Mechanics/HUD/Objectives/Objectives.tscn")
const GearScene = preload("res://SCENES/Mechanics/Option/GearHud.tscn")
var timer_ui_instance = null
var objectives_instance = null
var GearScene_instance = null # Remove it if it does not work

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

	add_gear_hud() # Renamed to follow convention.
	add_objectives_hud()
	ObjectiveManager.set_total_signage(signage_count)  # Use the per-floor signage count
	reset_objectives_for_new_floor(signage_count)

func add_gear_hud(): # Changed this
	GearScene_instance = GearScene.instantiate() # Instantiate and assign it in memory
	add_child(GearScene_instance)

func add_objectives_hud():
	objectives_instance = ObjectivesScene.instantiate()
	add_child(objectives_instance)
	objectives_instance.set_signage_count(signage_count)

func reset_objectives_for_new_floor(signage_count: int):
	ObjectiveManager.set_total_signage(signage_count)

func update_game_objective(index: int, text: String):
	var objectives_hud = get_node("Objectives")
	if objectives_hud:
		objectives_hud.update_objective(index, text)

func _exit_tree():
	# Optional: Stop timer if player exits scene without using the door
	# (e.g., if they quit the game or use a different exit)
	if timer_manager and timer_manager.timer_running and timer_manager.current_floor == floor_number:
		timer_manager.stop_timer()
		timer_manager.save_times()
	
