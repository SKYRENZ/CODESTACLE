extends Control

@onready var transition_fx = preload("res://BGM/button.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuMusic.play_menu_music()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# goes to the login scene
func _on_start_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().change_scene_to_file("res://SCENES/Main/Login.tscn")
