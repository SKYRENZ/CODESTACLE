extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_zone = $HitZone

func _ready():
	hit_zone.body_entered.connect(_on_hit_entered)
	animated_sprite.play("trap_loop")

func _on_hit_entered(body):
	if body.is_in_group("player"):
		print("🔥 Player hit the trap!")
		get_tree().reload_current_scene()
