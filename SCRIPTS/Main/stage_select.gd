extends Control

@onready var transition_fx = preload("res://BGM/button.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().change_scene_to_file("res://SCENES/FLOOR/Tutorial/Tutorial.tscn")
