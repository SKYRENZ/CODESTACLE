extends CanvasLayer

signal intro_finished  

@export var display_time: float = 5.0  

@onready var label = $Label
@onready var dim_screen = $ColorRect

func _ready():
	print("[SceneIntro] SceneIntro started")  

	# Disable player movement
	disable_player_movement(true)

	# Set the text to Baybayin characters
	label.text = "ᜃᜑᜒᜍᜉᜈ᜔"  

	# Ensure the intro is visible at the start
	label.modulate.a = 0
	dim_screen.modulate.a = 0.5  

	var tween = create_tween()  

	# Fade in text
	tween.tween_property(label, "modulate:a", 1.0, 2.0)
	tween.tween_property(dim_screen, "modulate:a", 0.5, 2.0)

	# Wait for display time
	await get_tree().create_timer(display_time).timeout

	# Fade out
	tween = create_tween()  
	tween.tween_property(label, "modulate:a", 0.0, 2.0)
	tween.tween_property(dim_screen, "modulate:a", 0.0, 2.0)

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
