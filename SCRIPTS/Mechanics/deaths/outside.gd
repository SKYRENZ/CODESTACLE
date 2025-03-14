extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("🔥 Player fell into toxic lava!")
		get_tree().reload_current_scene()  # Restart the game
