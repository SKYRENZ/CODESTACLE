extends Node2D

@onready var animation = $Area2D/AnimatedSprite2D
@onready var area = $Area2D

@export var tile_trigger: NodePath
@onready var tile_trigger_node = get_node(tile_trigger)

func _ready():
	animation.play("idle")
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("✅ Player stepped on the plate.")
		animation.play("pressed")
		tile_trigger_node.trigger_tile_removal()

func _on_body_exited(body):
	if body.is_in_group("player"):
		print("⬅️ Player left the plate.")
		animation.play("idle")
