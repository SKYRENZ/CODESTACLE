extends StaticBody2D

@onready var animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var area = $Area2D

func _ready():
	animation.stop()
	area.body_entered.connect(_on_Area2D_body_entered)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print("✅ Player landed! Platform breaking...")  
		
		animation.play("break")  

		await animation.animation_finished  

		print("⚠️ Platform disabled!")
		collision.set_deferred("disabled", true)  
		visible = false  # Hide platform

		# Make player fall
		if body.is_on_floor():
			await get_tree().process_frame  
			body.velocity.y = 500  
			body.move_and_slide()  

		# Wait 3 seconds before respawning the platform
		await get_tree().create_timer(3).timeout  
		_reset_platform()


func _reset_platform():
	print("🔄 Respawning platform...")
	visible = true  # Show the platform again
	collision.set_deferred("disabled", false)  # Enable collision again
	animation.play("idle")  # Reset animation
	animation.stop()
