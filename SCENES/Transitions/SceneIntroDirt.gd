extends CanvasLayer

signal intro_finished  

@export var display_time: float = 3.0  

@onready var label = $Label
@onready var sub_label = $SubLabel  # Reference to the new label
@onready var dim_screen = $ColorRect

func _ready():
	print("[SceneIntro] SceneIntro started")  

	# Disable player movement
	disable_player_movement(true)

	# Set the text for the main label and sub-label
	label.text = "ᜀᜅ᜔ᜇᜓᜋᜒ"  # Baybayin characters
	sub_label.text = "The Dirt"  # New text

	# Ensure the intro is visible at the start
	label.modulate.a = 0
	sub_label.modulate.a = 0  # Start with sub-label hidden
	dim_screen.modulate.a = 0.5  

	# Create a single tween for both fade-in and fade-out
	var tween = create_tween()

	# Fade in text and dim screen
	tween.tween_property(label, "modulate:a", 1.0, 3.0)  # Fade in over 3 seconds
	tween.tween_property(sub_label, "modulate:a", 1.0, 3.0)  # Fade in over 3 seconds
	tween.tween_property(dim_screen, "modulate:a", 0.5, 3.0)  # Fade in dim screen over 3 seconds

	# Wait for display time
	await get_tree().create_timer(display_time).timeout

	# Fade out text and dim screen
	tween.tween_property(label, "modulate:a", 0.0, 3.0)  # Fade out over 3 seconds
	tween.tween_property(sub_label, "modulate:a", 0.0, 3.0)  # Fade out over 3 seconds
	tween.tween_property(dim_screen, "modulate:a", 0.0, 3.0)  # Fade out dim screen over 3 seconds

	# Wait for fade-out to finish, then allow movement again
	await tween.finished

	disable_player_movement(false)  # ✅ Re-enable movement
	print("[SceneIntro] SceneIntro finished, emitting signal")  
	intro_finished.emit()  
	queue_free()  

func disable_player_movement(state: bool):
	var player = get_tree().get_first_node_in_group("player")  
	if player:
		player.set_movement_locked(state)  # ✅ Use set_movement_locked to stop movement
		print("[SceneIntro] Player movement locked:", state)
