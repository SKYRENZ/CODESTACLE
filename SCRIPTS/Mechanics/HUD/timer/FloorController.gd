extends Node2D

@export var floor_number: int = 0
@export var signage_count: int = 0
@export var npc_count: int = 0

var timer_manager = null
var timer_ui_scene = preload("res://SCENES/Mechanics/HUD/Timer/timer.tscn")
const ObjectivesScene = preload("res://SCENES/Mechanics/HUD/Objectives/Objectives.tscn")
const GearScene = preload("res://SCENES/Mechanics/Option/GearHud.tscn")
const ProgressBarScene = preload("res://SCENES/Mechanics/HUD/Progress Bar/progress bar.tscn")

const SceneIntro = preload("res://SceneIntro.tscn")  # ✅ SceneIntro preload

var timer_ui_instance = null
var objectives_instance = null
var GearScene_instance = null
var progress_bar_instance = null
var scene_intro_instance = null
var doors = []  

func _ready():
	print("[Floor %d] Loading..." % floor_number)

	if floor_number == 1:  # ✅ SceneIntro only for Floor 1
		print("[Floor 1] Playing SceneIntro...")
		scene_intro_instance = SceneIntro.instantiate()
		add_child(scene_intro_instance)
		scene_intro_instance.intro_finished.connect(_on_intro_finished)
	else:
		print("[Floor %d] Skipping SceneIntro, starting setup immediately." % floor_number)
		_on_intro_finished()  # ✅ Skip SceneIntro for other floors

func _on_intro_finished():
	print("[Floor %d] SceneIntro finished. Starting game setup..." % floor_number)

	timer_manager = get_node_or_null("/root/FloorTimerManager")
	if timer_manager == null:
		printerr("FloorTimerManager not found!")
		return
	timer_manager.start_timer(floor_number)

	timer_ui_instance = timer_ui_scene.instantiate()
	add_child(timer_ui_instance)

	add_gear_hud()
	add_objectives_hud()
	add_progress_bar_hud()  

	ObjectiveManager.set_total_objectives(signage_count, npc_count)
	reset_objectives_for_new_floor(signage_count)

	doors = get_tree().get_nodes_in_group("door")
	print("Doors found:", doors.size())

	pass_info_to_player()

func add_gear_hud():
	GearScene_instance = GearScene.instantiate()
	add_child(GearScene_instance)

func add_objectives_hud():
	objectives_instance = ObjectivesScene.instantiate()
	add_child(objectives_instance)
	if objectives_instance.has_method("set_total_objectives_count"):
		objectives_instance.set_total_objectives_count(signage_count, npc_count)
	else:
		printerr("Error: ObjectivesHUD instance does not have set_total_objectives_count method!")

func add_progress_bar_hud():
	progress_bar_instance = ProgressBarScene.instantiate()
	add_child(progress_bar_instance)
	print("Progress bar instance created:", progress_bar_instance)

func update_progress_bar(value: float):
	var canvas_layer = get_tree().get_root().get_node("ProgressBar")
	if canvas_layer:
		print("CanvasLayer (ProgressBar) found:", canvas_layer.name)
		canvas_layer.update_progress(value)
	else:
		print("Error: CanvasLayer (ProgressBar) not found!")
		print("Current scene tree:", get_tree().get_root().get_children())

func reset_objectives_for_new_floor(signage_count: int):
	ObjectiveManager.set_total_objectives(signage_count, npc_count)

func update_game_objective(index: int, text: String):
	var objectives_hud = get_node("Objectives")
	if objectives_hud:
		objectives_hud.update_objective(index, text)

func _exit_tree():
	if timer_manager and timer_manager.timer_running and timer_manager.current_floor == floor_number:
		timer_manager.stop_timer()
		timer_manager.save_times()

func pass_info_to_player():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		player.doors = doors
		player.max_distance = calculate_max_distance()
		print("Player info passed: Doors =", doors.size(), ", Max Distance =", player.max_distance)

func calculate_max_distance() -> float:
	var max_dist = 0.0
	var player = get_node("Player")  # Adjust path if needed
	if not player:
		print("Error: Player node not found!")
		return 0.0

	for door in doors:
		if door:
			var dist = player.global_position.distance_to(door.global_position)
			if dist > max_dist:
				max_dist = dist
	print("Max distance calculated:", max_dist)
	return max_dist
