extends Node2D

@onready var coin : AnimatedSprite2D = $AnimatedSprite2D
var coin_sfx: AudioStream = preload("res://BGM/coins.mp3")  # 🪙 Preload coin sound

func _ready() -> void:
	coin.play("default")

func _on_coin_picked_up() -> void:
	CoinManager.add_coin()  # Update coin count

	# Play coin sound (detach from coin so it can live on)
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = coin_sfx
	sfx_player.bus = "SFX"
	get_tree().get_current_scene().add_child(sfx_player)  # Reparent to scene root
	sfx_player.play()

	# Auto-remove sound player after it's done
	sfx_player.connect("finished", Callable(sfx_player, "queue_free"))

	queue_free()  # Instantly free the coin node

func _on_body_entered(body) -> void:
	if body.name == "B-01":
		_on_coin_picked_up()
