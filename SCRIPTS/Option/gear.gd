extends CanvasLayer

@onready var transition_fx = preload("res://BGM/button.mp3")
var option_instance = null
var player = null
var timer_manager = null  

func _ready():
	# Ensure the HUD remains active when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Obtain a reference to the player node
	player = get_tree().get_nodes_in_group("player")[0]

	# Obtain a reference to the timer manager
	timer_manager = get_node_or_null("/root/FloorTimerManager")

	if timer_manager == null:
		print("ERROR: FloorTimerManager not found!")

func _on_Exit_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	var option_instance = get_tree().root.get_node_or_null("OptionInstance")
	if option_instance:
		option_instance.queue_free()
		print("Option scene removed!")

	get_tree().change_scene_to_file("res://SCENES/Main/main_menu.tscn")

func _on_option_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	if option_instance == null:
		var option_scene = ResourceLoader.load("res://SCENES/Mechanics/Option/volume_sliders.tscn")
		if option_scene:
			option_instance = option_scene.instantiate()
			option_instance.name = "OptionInstance"
			get_tree().root.add_child(option_instance)
			print("Option scene displayed!")
		else:
			print("Error: Failed to load option.tscn!")
	else:
		print("Option scene is already displayed!")

func _on_resume_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().paused = false

	# ✅ Ensure the timer resumes correctly
	if timer_manager:
		timer_manager.set_timer_paused(false)
	
	if player:
		player.set_movement_locked(false)

	# ✅ Properly close and free the gear menu instance
	queue_free()  # Instead of just hiding it, remove it completely

	print("Game Resumed, Timer Resumed, Gear Menu Closed!")  
  
