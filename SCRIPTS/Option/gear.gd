extends CanvasLayer

@onready var transition_fx = preload("res://BGM/button.mp3")
var option_instance = null
var player = null
var timer_manager = null  
var exit_popup_instance = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		print("ERROR: No player found in group 'player'")

	timer_manager = get_node_or_null("/root/FloorTimerManager")
	if timer_manager == null:
		print("ERROR: FloorTimerManager not found!")

func _handle_option_scene(load: bool) -> void:
	if load:
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
	else:
		if option_instance:
			option_instance.queue_free()
			option_instance = null
			print("Option scene removed!")

func _on_Exit_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	_handle_option_scene(false)

	var exit_popup_instance = get_tree().root.get_node_or_null("ExitPopUp")
	if exit_popup_instance == null:
		var exit_popup_scene = ResourceLoader.load("res://SCENES/Mechanics/Option/Exit_PopUp.tscn")
		if exit_popup_scene:
			exit_popup_instance = exit_popup_scene.instantiate()
			exit_popup_instance.name = "ExitPopUp"
			get_tree().root.add_child(exit_popup_instance)
			print("Exit pop-up displayed!")
		else:
			print("Error: Failed to load Exit_PopUp.tscn!")
	else:
		print("Exit pop-up is already displayed!")

	call_deferred("_close_and_free")

func _close_and_free() -> void:
	print("Closing and freeing the CanvasLayer instance...")
	queue_free()

func _on_option_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	_handle_option_scene(true)

func _on_resume_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().paused = false

	if timer_manager:
		timer_manager.set_timer_paused(false)
	
	if player:
		player.set_movement_locked(false)

	queue_free()
	print("Game Resumed, Timer Resumed, Gear Menu Closed!")  

func _on_quit_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	_handle_option_scene(false)
	queue_free()
	get_tree().change_scene_to_file("res://SCENES/Main/main_menu.tscn")

func _on_floor_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	_handle_option_scene(false)
	queue_free()
	get_tree().change_scene_to_file("res://SCENES/Main/stage_select.tscn")

func _on_restart_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	_handle_option_scene(false)

	if timer_manager:
		timer_manager.stop_timer()
		timer_manager.floor_times = {}
		timer_manager.save_times()
		timer_manager.start_timer(0)

	# Inform LetterBox to clean up
	var letterbox = get_tree().root.get_node_or_null("LetterBox")
	if letterbox:
		letterbox.force_reset()

	# 💡 Immediately free the gear menu BEFORE reloading
	queue_free()

	await get_tree().process_frame

	# 🔄 Now reload the scene safely after gear is removed
	get_tree().reload_current_scene()

	print("Game restarted!")
