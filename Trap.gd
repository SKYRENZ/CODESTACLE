extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var trigger_area = $TriggerArea
@onready var hit_zone = $HitZone

func _ready():
	trigger_area.body_entered.connect(_on_trigger_entered)
	hit_zone.body_entered.connect(_on_hit_entered)

func _on_trigger_entered(body):
	if body.is_in_group("player"):
		print("⚠️ Trap triggered by player")
		animated_sprite.play("trap_loop") # Make sure this is the correct animation name

func _on_hit_entered(body):
	if body.is_in_group("player"):
		print("🔥 Player hit the trap!")
		get_tree().reload_current_scene()
