extends CanvasLayer

@onready var transition_fx = preload("res://BGM/button.mp3")
var option_instance = null
var player = null
var timer_manager = null  
var exit_popup_instance = null

func _ready():
	# Ensure the HUD remains active when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Obtain a reference to the player node
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		print("ERROR: No player found in group 'player'")

	# Obtain a reference to the timer manager
	timer_manager = get_node_or_null("/root/FloorTimerManager")

	if timer_manager == null:
		print("ERROR: FloorTimerManager not found!")

func _on_Exit_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)

	# Remove OptionInstance if it exists
	var local_option_instance = get_tree().root.get_node_or_null("OptionInstance")
	if local_option_instance:
		local_option_instance.queue_free()
		print("Option scene removed!")

	# Display exit confirmation pop-up (if not already present)
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

	# Close the current gear/pause menu (this CanvasLayer)
	queue_free()

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

	# Ensure the timer resumes correctly
	if timer_manager:
		timer_manager.set_timer_paused(false)
	
	if player:
		player.set_movement_locked(false)

	# Properly close and free the gear menu instance
	queue_free()  # Instead of just hiding it, remove it completely

	print("Game Resumed, Timer Resumed, Gear Menu Closed!")  

func _on_quit_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)

	var local_option_instance = get_tree().root.get_node_or_null("OptionInstance")
	if local_option_instance:
		local_option_instance.queue_free()
		print("Option scene removed!")

	# Close the gear menu
	queue_free()

	# Then change to the main menu
	get_tree().change_scene_to_file("res://SCENES/Main/main_menu.tscn")

func _on_floor_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	
	# Remove any existing option scene
	var local_option_instance = get_tree().root.get_node_or_null("OptionInstance")
	if local_option_instance:
		local_option_instance.queue_free()
		print("Option scene removed!")
	
	# Close the current gear/pause menu (this CanvasLayer)
	queue_free()
	
	# Change to the stage select scene immediately
	get_tree().change_scene_to_file("res://SCENES/Main/stage_select.tscn")

func _on_restart_pressed() -> void:
	# Play transition sound effect
	AudioPlayer.play_FX(transition_fx, -12.0)

	# Remove any existing option scene
	var local_option_instance = get_tree().root.get_node_or_null("OptionInstance")
	if local_option_instance:
		local_option_instance.queue_free()
		print("Option scene removed!")

	# Reset the timer
	if timer_manager:
		# Stop the timer if it's running
		timer_manager.stop_timer()
		
		# Clear recorded times
		timer_manager.floor_times = {}
		
		# Save the cleared times
		timer_manager.save_times()
		
		# Ensure timer is not paused
		timer_manager.set_timer_paused(false)
		
		# Restart timer for the first floor (or any desired floor)
		timer_manager.start_timer(0)

	# Reload the current scene to restart the game
	get_tree().reload_current_scene()

	# Print confirmation message
	print("Game restarted!")
