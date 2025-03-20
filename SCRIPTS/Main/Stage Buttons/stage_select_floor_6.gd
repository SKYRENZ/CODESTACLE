extends Button


@onready var transition_fx = preload("res://BGM/button.mp3")

func _on_pressed() -> void:
	MenuMusic.stop_music()
	MenuMusic.play_slum_music()
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().change_scene_to_file("res://SCENES/FLOOR/Slums/floor 6.tscn")
