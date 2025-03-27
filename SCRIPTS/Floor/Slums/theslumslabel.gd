extends Node2D

@onready var canvas_layer = $CanvasLayer  # Reference to CanvasLayer

func _ready():
	await get_tree().process_frame  # Ensure nodes are ready

	# Call the function in CanvasLayer to show the title
	if canvas_layer:
		canvas_layer.show_title("ᜆ᜔ᜑᜒ ᜐ᜔ᜎᜓᜋ᜔ᜐ᜔", 5.0)
	else:
		print("❌ ERROR: CanvasLayer not found!")
