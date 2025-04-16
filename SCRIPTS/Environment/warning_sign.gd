extends Node2D

@onready var warningsign: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	warningsign.play("default")
