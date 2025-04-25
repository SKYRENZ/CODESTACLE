extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $".."
@onready var timer: Timer = $Timer  # Ensure this points to the Timer node in your scene
var is_animation_playing: bool = false  # Track the animation state

func _ready() -> void:
	# Debugging: Check if the Timer node is valid
	if timer == null:
		print("Error: Timer node not found!")
		return

	# Configure the timer
	timer.wait_time = 4.0  
	timer.one_shot = false  
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()  
	print("Timer started with wait time:", timer.wait_time)

	# Connect the body_entered signal
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("body_entered signal connected.")

func _on_timer_timeout() -> void:
	# Toggle the animation state every 3 seconds
	if is_animation_playing:
		animated_sprite_2d.stop()  # Stop the animation
	else:
		animated_sprite_2d.play("default")  # Start the animation
	is_animation_playing = !is_animation_playing  # Toggle the state

func _on_body_entered(body):
	# Debugging: Check if the collision is detected
	print("Collision detected with:", body.name)

	# Only reload the scene if the animation is playing
	if body.is_in_group("player"):
		print("Player is in group 'player'. Animation playing:", is_animation_playing)
		if is_animation_playing:
			print("Player collided while animation is playing. Reloading scene...")
			get_tree().reload_current_scene()
		else:
			print("Player collided but animation is not playing. No action taken.")
