extends CanvasLayer

@onready var transition_fx = preload("res://BGM/button.mp3")
var option_instance = null  # Store a reference to the Option scene instance

func _ready():
	# Ensure the button's pressed signal is connected
	if not is_connected("pressed", Callable(self, "_on_pressed")):
		connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed():
	MenuMusic.stop_music() 
	AudioPlayer.play_FX(transition_fx, -12.0)
	if option_instance == null:  # Check if the Option scene is not already loaded
		var option_scene = ResourceLoader.load("res://SCENES/Mechanics/Option/Option.tscn")  # Load the scene
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
