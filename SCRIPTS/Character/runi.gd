extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	animated_sprite_2d.play("idle")

func interact_with_npc():
	print("[DEBUG] NPC interaction detected!")  # Debug print
	var player_data = get_node_or_null("/root/PlayerData")
	if player_data:
		player_data.increment_npcs_engaged()
		print("[DEBUG] NPC count increased to:", player_data.get_npcs_engaged())  # Debug print
	else:
		print("[ERROR] PlayerData node not found!")
