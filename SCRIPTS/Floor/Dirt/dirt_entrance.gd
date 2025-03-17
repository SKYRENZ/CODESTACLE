extends Node2D

@export var floor_number: int = 11
@onready var inventory = $UI/Validation  # Reference to Inventory UI
@onready var player = get_node("CharacterBody2D")

var interactable_items: Array = []  # Store all interactable items in range

func _ready():
	print("🟢 Current Floor Number:", floor_number)
	
	# Fetch Floor Data if available
	if FloorData.has_method("get_floor_data"):
		var floor_data = FloorData.get_floor_data(floor_number)
		print("📜 Loaded Floor Data:", floor_data)

	if player:
		var spawn_point = get_node("Marker2D")
		if spawn_point:
			player.spawn_point = spawn_point
			print("✅ Initial spawn point set at:", spawn_point.global_position)
		else:
			print("❌ Error: Default spawn Marker2D not found!")

		# Connect all checkpoints
		var checkpoints = get_tree().get_nodes_in_group("checkpoint")
		print("🟢 Found checkpoints:", checkpoints.size())

		for checkpoint in checkpoints:
			if checkpoint is Area2D:
				checkpoint.connect("body_entered", _on_checkpoint_reached)
				print("🔹 Checkpoint connected:", checkpoint.name)
		
		# Hide inventory initially
		if inventory:
			inventory.visible = false
	else:
		print("❌ Error: Player not found!")

# ✅ Change floors dynamically
func change_floor(new_floor: int):
	floor_number = new_floor
	print("🔄 Floor changed to:", floor_number)

	if FloorData.has_method("get_floor_data"):
		var new_floor_data = FloorData.get_floor_data(floor_number)
		print("📜 Updated Floor Data:", new_floor_data)

# 🏁 Checkpoint system
func _on_checkpoint_reached(body):
	if body.is_in_group("player"):
		var checkpoint = body.get_parent()
		var spawn_marker = checkpoint.find_child("Spawnpoint", true, false)

		if spawn_marker:
			body.spawn_point = spawn_marker
			print("✅ Checkpoint reached! New spawn:", spawn_marker.global_position)
		else:
			print("❌ ERROR: 'Spawnpoint' missing in Checkpoint!")

# 🎯 Detect when player enters an item's interaction area
func _on_item_area_entered(area):
	if area.is_in_group("collectible"):
		var item = area.get_parent()
		if item and item not in interactable_items:
			interactable_items.append(item)
			print("🟡 Item in range:", item.name)

# 🎯 Detect when player exits an item's interaction area
func _on_item_area_exited(area):
	var item = area.get_parent()
	if item and item in interactable_items:
		interactable_items.erase(item)
		print("⚫ Item out of range:", item.name)

# 🎯 Handle player collecting an item
func _process(_delta):
	if Input.is_action_just_pressed("interact") and interactable_items.size() > 0:
		_on_item_collected(interactable_items[0])  # Collect first item in range

	if Input.is_action_just_pressed("toggle_validation") and inventory:
		inventory.visible = not inventory.visible  # Toggle visibility

# 🎯 Store item in validation UI
func _on_item_collected(item):
	if not inventory:
		print("❌ Error: Inventory UI not found!")
		return
	
	if item and inventory.validate_item(item.name):
		var item_texture = item.get_node("Sprite2D").texture if item.has_node("Sprite2D") else null
		
		if item_texture:
			inventory.add_item(item.name, item_texture)  # ✅ Store in inventory
			interactable_items.erase(item)  # ✅ Remove from list
			item.queue_free()  # Remove from scene
			print("✅ Item stored:", item.name)
			inventory.visible = true
		else:
			print("❌ Error: Item texture not found for", item.name)
	else:
		if item:
			inventory.show_wrong_feedback()
			item.return_to_scene()
			print("❌ Item rejected:", item.name)
		else:
			print("❌ Error: No interactable item found!")
