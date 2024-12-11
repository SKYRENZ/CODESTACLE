extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# goes to signup scene
func _on_signup_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/signup_screen.tscn")

func _on_login_button_pressed() -> void:
	pass # Replace with function body.
