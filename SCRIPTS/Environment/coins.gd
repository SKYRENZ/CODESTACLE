extends Node2D

@onready var coin : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	coin.play("default")
