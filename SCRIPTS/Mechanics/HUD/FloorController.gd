extends Node2D

@export var floor_number: int = 0
@export var signage_count: int = 0
@export var npc_count: int = 0


var timer_manager = null
var timer_ui_scene = preload("res://SCENES/Mechanics/HUD/Timer/timer.tscn")
const ObjectivesScene = preload("res://SCENES/Mechanics/HUD/Objectives/Objectives.tscn")
const GearScene = preload("res://SCENES/Mechanics/Option/GearHud.tscn")
const ProgressBarScene = preload("res://SCENES/Mechanics/HUD/Progress Bar/ProgressBar.tscn")
const CoinCountScene = preload("res://SCENES/Mechanics/HUD/CoinCount.tscn")
const SceneIntro = preload("res://SCENES/Transitions/SceneIntro.tscn")  # ✅ SceneIntro preload
var Coin_Count = null
var timer_ui_instance = null
var objectives_instance = null
var GearScene_instance = null
var progress_bar_instance = null
var scene_intro_instance = null
var doors = []  

func _ready():
	print("[Floor %d] Loading..." % floor_number)

#sceneintro function
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
	add_Coint_Count()
	add_gear_hud()
	add_objectives_hud()
	add_progress_bar_hud()  

	ObjectiveManager.set_total_objectives(signage_count, npc_count)
	reset_objectives_for_new_floor(signage_count)

	doors = get_tree().get_nodes_in_group("door")
	print("Doors found:", doors.size())

func add_Coint_Count():
	Coin_Count = CoinCountScene.instantiate()
	add_child(Coin_Count)

	# Get the CoinManager node
	var coin_manager = get_node_or_null("/root/CoinManager")
	if coin_manager == null:
		printerr("CoinManager not found!")
		return

	# Connect the coin_count_updated signal to the Coin_Count script
	coin_manager.coin_count_updated.connect(Coin_Count.update_coin_count)
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


func reset_objectives_for_new_floor(new_signage_count: int):
	ObjectiveManager.set_total_objectives(signage_count, npc_count)

func update_game_objective(index: int, text: String):
	var objectives_hud = get_node("Objectives")
	if objectives_hud:
		objectives_hud.update_objective(index, text)

func _exit_tree():
	if timer_manager and timer_manager.timer_running and timer_manager.current_floor == floor_number:
		timer_manager.stop_timer()
		timer_manager.save_times()
