extends AnimatedSprite2D

@onready var flag : AnimatedSprite2D = $"."

func _ready() -> void:
	flag.play("default")
