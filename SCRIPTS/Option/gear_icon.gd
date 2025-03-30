extends CanvasLayer

@onready var transition_fx = preload("res://BGM/button.mp3")
var option_instance = null  # Store a reference to the Option scene instance
var was_timer_paused = false  # Track whether the timer was already paused

func _on_pressed():
	MenuMusic.stop_music() 
	AudioPlayer.play_FX(transition_fx, -12.0)

	var player = get_tree().get_first_node_in_group("player")  # Get player
	var timer_manager = get_node_or_null("/root/FloorTimerManager")  # Get timer

	if option_instance == null:  # If the Option menu is NOT open
		var option_scene = ResourceLoader.load("res://SCENES/Mechanics/Option/Option.tscn")  
		if option_scene:
			option_instance = option_scene.instantiate()
			option_instance.name = "OptionInstance"
			get_tree().root.add_child(option_instance)

			# PAUSE LOGIC: Stop player movement and freeze timer
			if player:
				player.set_movement_locked(true)  
			if timer_manager:
				was_timer_paused = timer_manager.get_timer_paused()  # Store current timer state
				timer_manager.set_timer_paused(true)  # Pause timer

			print("Option scene displayed!")
		else:
			print("Error: Failed to load option.tscn!")
	else:
		# CLOSE LOGIC: Remove the menu properly and reset instance reference
		option_instance.queue_free()
		option_instance = null  # ✅ Fix: Reset reference after closing

		# RESUME LOGIC: Enable player movement but ONLY resume the timer if it was running before
		if player:
			player.set_movement_locked(false)
		if timer_manager and not was_timer_paused:  # Only resume if it wasn't paused before
			timer_manager.set_timer_paused(false)  

		print("Option scene closed, resuming game if it wasn't paused before!")  
