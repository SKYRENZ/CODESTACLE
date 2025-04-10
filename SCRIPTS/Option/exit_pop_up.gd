extends CanvasLayer

func _on_yes_pressed() -> void:
	print("Exiting game...")
	get_tree().quit()

func _on_no_pressed() -> void:
	print("Exit canceled")

	# Re-open the pause menu
	var option_canvas_scene = ResourceLoader.load("res://SCENES/Mechanics/Option/Option.tscn")
	if option_canvas_scene:
		var option_canvas_instance = option_canvas_scene.instantiate()
		get_tree().root.add_child(option_canvas_instance)
		print("Pause menu reopened!")
	else:
		print("Error: Failed to load option_canvas.tscn!")

	# Remove the exit popup
	queue_free()
