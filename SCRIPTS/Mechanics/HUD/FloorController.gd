extends Node2D

@export var floor_number: int = 0
@export var signage_count: int = 0
@export var npc_count: int = 0

@export var transition_scene = preload("res://SCENES/Transitions/Transition.tscn")  # Path to your Transition scene
@export var included_scenes = [  # List of scenes where the transition should be shown
	"res://SCENES/FLOOR/Slums/floor 2.tscn",
	"res://SCENES/FLOOR/Floor3.tscn",
	"res://SCENES/FLOOR/Floor4.tscn",
	"res://SCENES/FLOOR/Floor5.tscn"
]


var timer_ui_scene = preload("res://SCENES/Mechanics/HUD/Timer/timer.tscn")
const ObjectivesScene = preload("res://SCENES/Mechanics/HUD/Objectives/Objectives.tscn")
const GearScene = preload("res://SCENES/Mechanics/Option/GearHud.tscn")
const ProgressBarScene = preload("res://SCENES/Mechanics/HUD/Progress Bar/ProgressBar.tscn")
const CoinCountScene = preload("res://SCENES/Mechanics/HUD/coinCount/CoinCount.tscn")
const SceneIntro = preload("res://SCENES/Transitions/SceneIntro.tscn") 


var timer_manager = null
var Coin_Count = null
var timer_ui_instance = null
var objectives_instance = null
var GearScene_instance = null
var progress_bar_instance = null
var scene_intro_instance = null
var doors = []



func _ready():
	print("[Floor %d] Loading..." % floor_number)

	# Automatically handle the transition based on the current scene
	var current_scene_path = get_tree().current_scene.scene_file_path
	print("📂 Current Scene Path:", current_scene_path)

	if current_scene_path in included_scenes:
		print("✅ Transition required for this scene.")
		show_transition()
	else:
		print("❌ Transition not required for this scene.")
		handle_scene_intro()

func show_transition():
	print("[FloorController] Showing Transition...")
	var transition_instance = transition_scene.instantiate()
	add_child(transition_instance)  # Add the transition as a child of FloorController

	# Access LoadingSprite1 and LoadingSprite2 and play their animations
	var sprite1 = transition_instance.get_node("LoadingSprite1")
	var sprite2 = transition_instance.get_node("LoadingSprite2")

	if sprite1:
		print("🎬 Playing loading1 animation on LoadingSprite1...")
		sprite1.play("loading1")
	else:
		print("⚠ ERROR: LoadingSprite1 not found in Transition scene!")

	if sprite2:
		print("🎬 Playing loading2 animation on LoadingSprite2...")
		sprite2.play("loading2")
	else:
		print("⚠ ERROR: LoadingSprite2 not found in Transition scene!")

	# Connect the fade_out_finished signal to proceed after the transition
	transition_instance.connect("fade_out_finished", Callable(self, "_on_transition_finished"))

func _on_transition_finished():
	print("[FloorController] Transition finished. Proceeding to SceneIntro...")
	handle_scene_intro()

func handle_scene_intro():
	# SceneIntro logic
	if floor_number == 1:  # ✅ SceneIntro only for Floor 1
		print("[Floor 1] Playing SceneIntro...")
		scene_intro_instance = SceneIntro.instantiate()
		add_child(scene_intro_instance)

		# Correctly connect the signal using Callable
		scene_intro_instance.intro_finished.connect(Callable(self, "_on_intro_finished"))
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
	coin_manager.coin_count_updated.connect(Callable(Coin_Count, "update_coin_count"))

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
