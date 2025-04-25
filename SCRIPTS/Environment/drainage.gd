extends AnimatedSprite2D

@onready var drainage: AnimatedSprite2D = $"."

func _ready() -> void:
	drainage.play("default")
