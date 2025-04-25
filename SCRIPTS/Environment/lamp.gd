extends AnimatedSprite2D

@onready var lamp : AnimatedSprite2D = $"."

func _ready() -> void:
	lamp.play("default")
