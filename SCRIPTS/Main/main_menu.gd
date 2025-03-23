extends Control

@onready var transition_fx = preload("res://BGM/button.mp3")
var option_instance = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuMusic.play_menu_music()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().change_scene_to_file("res://SCENES/Main/stage_select.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/Main/quit_confirmation.tscn")


func _on_option_button_pressed() -> void:
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
