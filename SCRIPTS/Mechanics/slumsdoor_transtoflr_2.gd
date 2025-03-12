extends Node2D

@export var target_scene: String = "res://SCENES/FLOOR/Slums/Floor 5.tscn"  
@export var target_floor_number: int = 5  # The floor number player is going to
@onready var sprite = $SlumssDoor2
@onready var area = $Area2D

var player_in_area = false
var timer_manager = null

func _ready():
	print("SlumssDoor2 found?:", sprite != null)  # Debug
	if sprite:
		print("SlumssDoor2 is set up correctly.")

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	
	# Get reference to the timer manager
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	if timer_manager == null:
		printerr("FloorTimerManager not found!")

func _on_body_entered(body):              
	if body.is_in_group("player"):
		player_in_area = true
		print("Checkpoint activated. Changing scene...")
		
		# Stop the timer for current floor (if running)
		if timer_manager and timer_manager.timer_running:
			var elapsed_time = timer_manager.stop_timer()
			
			# Save the times
			timer_manager.save_times()
			
			# Show completion time to player (optional)
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
		print("Error: Scene path is incorrect:", target_scene)

# Optional: Show completion message with time
func _show_completion_message(elapsed_time: float) -> void:
	# You can implement this to show a popup or UI notification
	# with the time it took to complete the floor
	print("Floor completed in: " + timer_manager.format_time(elapsed_time))
	
	# Example: Create a popup label (you'll need to implement this part)
	# var popup = TimeCompletionPopup.instance()
	# popup.set_time(elapsed_time)
	# get_tree().root.add_child(popup)
