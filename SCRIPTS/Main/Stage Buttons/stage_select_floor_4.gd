extends Button


@onready var transition_fx = preload("res://BGM/button.mp3")

func _on_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().change_scene_to_file("res://SCENES/FLOOR/Slums/Floor 4.tscn")
