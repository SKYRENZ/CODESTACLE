extends Node2D

@onready var inventory = $UI/Validation  # Reference to Inventory UI
@onready var player = get_node("CharacterBody2D")

var interactable_item: Node = null  # Store the nearest interactable item

func _ready():
	if player:
		# ✅ Set default spawn point
		var spawn_point = get_node("Marker2D")
		if spawn_point:
			player.spawn_point = spawn_point
			print("✅ Initial spawn point set at:", spawn_point.global_position)
		else:
			print("❌ Error: Default spawn Marker2D not found!")

		# ✅ Connect all checkpoints
		var checkpoints = get_tree().get_nodes_in_group("checkpoint")
		print("🟢 Found checkpoints:", checkpoints.size())

		for checkpoint in checkpoints:
			if checkpoint is Area2D:
				checkpoint.connect("body_entered", _on_checkpoint_reached)
				print("🔹 Checkpoint connected:", checkpoint.name)
		
		# Initially hide the inventory validation UI
		if inventory:
			inventory.visible = false  # Hide the UI initially
	else:
		print("❌ Error: Player not found!")

# 🏁 Handle checkpoint reach
func _on_checkpoint_reached(body):
	if body.is_in_group("player"):
		var checkpoint = body.get_parent()
		var spawn_marker = checkpoint.find_child("Spawnpoint", true, false)

		if spawn_marker:
			body.spawn_point = spawn_marker  # ✅ Set spawn point
			print("✅ Checkpoint reached! New spawn:", spawn_marker.global_position)
		else:
			print("❌ ERROR: 'Spawnpoint' missing in Checkpoint!")

# 🎯 Detect when player enters/exits an item's interaction area
func _on_item_area_entered(area):
	if area.is_in_group("collectible"):
		interactable_item = area.get_parent()
		print("🟡 Item in range:", interactable_item.name)

func _on_item_area_exited(area):
	if interactable_item and interactable_item == area.get_parent():
		interactable_item = null
		print("⚫ Item out of range")

# 🎯 Handle player collecting an item
func _process(delta):
	if Input.is_action_just_pressed("interact") and interactable_item:
		_on_item_collected(interactable_item)
	
	# Optionally, you can also make the UI visible when the player presses 'F' 
	# (or other designated input for interaction).
	if Input.is_action_just_pressed("interact") and inventory:
		inventory.visible = true  # Show the inventory UI when the player presses 'F'

# 🎯 Store item in validation UI
func _on_item_collected(item):
	if not inventory:
		print("❌ Error: Inventory UI not found!")
		return
	
	if item and inventory.validate_item(item.name):
		# Debugging: Ensure texture is correctly accessed
		var item_texture = item.get_node("Sprite2D").texture if item.has_node("Sprite2D") else null
		
		if item_texture:
			inventory.add_item(item.name, item_texture)  # ✅ Store in inventory
			item.queue_free()  # Remove from scene
			print("✅ Item stored:", item.name)
			inventory.visible = true  # Show the UI when an item is collected
		else:
			print("❌ Error: Item texture not found for", item.name)
	else:
		if item:
			inventory.show_wrong_feedback()  # ❌ Shake and red effect
			item.return_to_scene()  # Return to original position
			print("❌ Item rejected:", item.name)
		else:
			print("❌ Error: No interactable item found!")
