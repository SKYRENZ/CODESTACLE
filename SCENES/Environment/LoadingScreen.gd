extends CanvasLayer

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	print("✅ Loading screen READY!")
	hide()  # Hide initially

func start_loading(target_scene: String):
	print("🌟 Loading screen activated! Target scene:", target_scene)

	show()  
	animated_sprite.play()  

	await get_tree().create_timer(3.0).timeout  

	print("🔄 Switching to scene:", target_scene)
	get_tree().change_scene_to_file(target_scene)

	# ✅ Remove loading screen after changing scene
	queue_free()
