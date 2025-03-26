extends CanvasLayer

@onready var transition_fx = preload("res://BGM/button.mp3")
var option_instance = null 

func _on_Exit_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	# Remove the Option scene instance if it exists
	var option_instance = get_tree().root.get_node_or_null("OptionInstance")  # Use the unique name
	if option_instance:
		option_instance.queue_free()  # Remove the instance from the scene tree
		print("Option scene removed!")
		print("Current Scene Tree after removal: ", get_tree().root.get_children())  # Debug: Print scene tree
	else:
		print("Option scene not found in the scene tree!")
	
	# Change to the main menu scene
	get_tree().change_scene_to_file("res://SCENES/Main/main_menu.tscn")



func _on_option_pressed() -> void: 
	AudioPlayer.play_FX(transition_fx, -12.0)
	if option_instance == null:  # Check if the Option scene is not already loaded
		var option_scene = ResourceLoader.load("res://SCENES/Mechanics/Option/volume_sliders.tscn")  # Load the scene
		if option_scene:
			option_instance = option_scene.instantiate()  # Create an instance of the scene
			option_instance.name = "OptionInstance"  # Assign a unique name to the instance
			get_tree().root.add_child(option_instance)  # Add the scene instance to the scene tree
			print("Option scene displayed!")
			print("Current Scene Tree: ", get_tree().root.get_children())  # Debug: Print scene tree
		else:
			print("Error: Failed to load option.tscn!")
	else:
		print("Option scene is already displayed!")
