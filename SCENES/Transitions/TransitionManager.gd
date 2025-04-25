extends CanvasLayer

signal fade_out_finished

func _ready():
	print("[Transition] Transition started")
	
	# Access LoadingSprite1 and LoadingSprite2 and play their animations
	var sprite1 = $LoadingSprite1
	var sprite2 = $LoadingSprite2

	if sprite1:
		print("🎬 Playing loading1 animation on LoadingSprite1...")
		sprite1.play("loading1")
	else:
		print("⚠ ERROR: LoadingSprite1 not found!")

	if sprite2:
		print("🎬 Playing loading2 animation on LoadingSprite2...")
		sprite2.play("loading2")
	else:
		print("⚠ ERROR: LoadingSprite2 not found!")

	# Simulate fade-out completion after 3 seconds
	await get_tree().create_timer(3.0).timeout
	emit_signal("fade_out_finished")
	queue_free()
