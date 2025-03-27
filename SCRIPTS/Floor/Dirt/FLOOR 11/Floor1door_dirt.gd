extends Node2D

@export var target_scene: String = "res://SCENES/FLOOR/Dirt/Floor 1 Dirt.tscn"  
@export var target_floor_number: int = 11  # The floor number player is going to
@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D

var player_in_area = false
var timer_manager = null

func _ready():
	print("SlumssDoor2 found?:", sprite != null)  # Debugging check
	if sprite:
		print("SlumssDoor2 is set up correctly.")
	else:
		printerr("Error: AnimatedSprite2D not found in scene!")

	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)
	else:
		printerr("Error: Area2D not found in scene!")

	# Get reference to the timer manager
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	if timer_manager == null:
		printerr("Error: FloorTimerManager not found! Make sure it exists in the scene tree.")
	else:
		print("FloorTimerManager found successfully!")

func _on_body_entered(body):              
	if body.is_in_group("player"):
		player_in_area = true
		print("Checkpoint activated. Changing scene...")

		# Stop the timer for current floor (if running)
		if timer_manager and timer_manager.timer_running:
			var elapsed_time = timer_manager.stop_timer()

			# Save the times
			timer_manager.save_times()

			# Show completion time to player
			_show_completion_message(elapsed_time)

		call_deferred("_change_scene")  # Use deferred call to avoid physics callback issue

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false

func _change_scene():
	MenuMusic.stop_slum_music()	
	if ResourceLoader.exists(target_scene):
		get_tree().change_scene_to_file(target_scene)  # Change scene after physics step
	else:
		printerr("Error: Scene path is incorrect or does not exist:", target_scene)

# Show completion message with time
func _show_completion_message(elapsed_time: float) -> void:
	if timer_manager and timer_manager.has_method("format_time"):
		print("Floor completed in: " + timer_manager.format_time(elapsed_time))
	else:
		printerr("Error: Timer manager is missing or format_time() function is undefined.")
	
	# Optional: Display popup message
	var popup = Label.new()
	popup.text = "Floor completed in: " + str(elapsed_time) + " seconds"
	popup.add_theme_font_size_override("font_size", 30)
	popup.set_position(Vector2(400, 200))
	get_tree().root.add_child(popup)

	# Auto-remove after 3 seconds
	var timer = Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.timeout.connect(func():
		popup.queue_free()
		timer.queue_free()
	)
	get_tree().root.add_child(timer)
	timer.start()
