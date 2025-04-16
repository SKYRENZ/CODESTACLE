extends Node2D

@onready var coin : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	coin.play("default")

func _on_coin_picked_up() -> void:
	CoinManager.add_coin()  # Use the global CoinManager
	queue_free()  # Remove the coin from the scene

func _on_body_entered(body) -> void:
	if (body.name == "B-01"): # Ensure only the player triggers the pickup
		_on_coin_picked_up()
