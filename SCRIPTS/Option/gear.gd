extends CanvasLayer

func _on_Exit_pressed() -> void:
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
