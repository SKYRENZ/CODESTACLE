extends CanvasLayer

func _on_button_pressed() -> void:
	# Remove the CanvasLayer (and all its children) from the scene tree
	queue_free()
	print("CanvasLayer and its children have been removed from the scene tree!")


func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db(value))

func _on_bgm_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"),linear_to_db(value))

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(value))
