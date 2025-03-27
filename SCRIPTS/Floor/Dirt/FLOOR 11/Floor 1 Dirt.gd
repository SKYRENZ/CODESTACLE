extends Node2D

@export var floor_number: int = 12
@onready var inventory = $UI/Validation  # Reference to Inventory UI

func _ready():
	print("🟢 Loading Floor:", floor_number)

	var player = get_node_or_null("CharacterBody2D")
	if not player:
		print("❌ Error: Player not found!")
		return

	var spawn_point = get_node_or_null("Marker2D")  
	if spawn_point:
		player.spawn_point = spawn_point
		print("✅ Spawn point set at:", spawn_point.global_position)
	else:
		print("❌ Error: Marker2D missing!")

	var void_area = get_node_or_null("VoidArea")
	if void_area:
		void_area.connect("body_entered", _on_void_area_body_entered)
	
	for checkpoint in get_tree().get_nodes_in_group("checkpoint"):
		if checkpoint is Area2D:
			checkpoint.connect("body_entered", _on_checkpoint_reached)

# 🚨 Handle void area fall
func _on_void_area_body_entered(body):
	if body.is_in_group("player"):
		print("🚨 Player fell into void! Respawning...")
		body._on_player_died()

# 🏁 Handle checkpoint reach
func _on_checkpoint_reached(body):
	if body.is_in_group("player"):
		var spawn_marker = body.get_parent().find_child("Spawnpoint", true, false)
		if spawn_marker:
			body.spawn_point = spawn_marker
			print("✅ Checkpoint reached! New spawn:", spawn_marker.global_position)

# 🎯 Handle item collection
func _on_item_collected(item):
	if inventory and inventory.validate_item(item.name):
		inventory.add_item(item.name, item.get_texture())  
		item.queue_free()
		print("✅ Item stored:", item.name)
	else:
		inventory.show_wrong_feedback()
		item.return_to_scene()
		print("❌ Item rejected:", item.name)
