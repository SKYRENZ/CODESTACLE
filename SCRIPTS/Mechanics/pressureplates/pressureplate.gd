extends Node2D

@onready var animation = $Area2D/AnimatedSprite2D
@onready var area = $Area2D

@export var wall_path: NodePath  # Path to the wall node
@onready var wall = get_node(wall_path)

func _ready():
	animation.play("idle")
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("✅ Player stepped on the plate.")
		animation.play("pressed")
		if wall and wall.has_node("DIRTWALL"):
			var wall_animation = wall.get_node("DIRTWALL")  # Access the AnimatedSprite2D
			wall_animation.play("wallanimation")  # Play the wall animation
			
			# Access the SpriteFrames resource to get the frame count
			var sprite_frames = wall_animation.sprite_frames
			var frame_count = sprite_frames.get_frame_count("wallanimation")
			
			# Calculate the duration of the wallanimation
			var animation_duration = frame_count / 6.0  # Speed is 6.0
			
			# Wait for the animation to finish
			await get_tree().create_timer(animation_duration).timeout
			wall_animation.play("stop")  # Play the stop animation
			
			# Disable the collision
			if wall.has_node("StaticBody2D/CollisionShape2D"):
				var collision_shape = wall.get_node("StaticBody2D/CollisionShape2D")
				collision_shape.disabled = true  # Disable the collision

func _on_body_exited(body):
	if body.is_in_group("player"):
		print("⬅️ Player left the plate.")
		animation.play("idle")
