extends Node2D

func _ready():
	var player = get_node("CharacterBody2D")
	if player:
		# ✅ Set default spawn point
		var spawn_point = get_node("Marker2D")  
		if spawn_point:
			player.spawn_point = spawn_point
			print("✅ Initial spawn point set at:", spawn_point.global_position)
		else:
			print("❌ Error: Default spawn Marker2D not found in Underground!")

		# ✅ Connect Void Area if exists
		var void_area = get_node("VoidArea")
		if void_area:
			void_area.connect("body_entered", _on_void_area_body_entered)
			print("✅ Void area signal connected!")
		else:
			print("❌ Error: VoidArea not found in Underground!")

		# ✅ Connect all checkpoints in the scene
		var checkpoints = get_tree().get_nodes_in_group("checkpoint")
		print("🟢 Found checkpoints:", checkpoints.size())

		for checkpoint in checkpoints:
			if checkpoint is Area2D:
				checkpoint.connect("body_entered", _on_checkpoint_reached)
				print("🔹 Checkpoint connected:", checkpoint.name)
	else:
		print("❌ Error: CharacterBody2D (Player) not found in Underground!")

# 🚨 Handle when player falls into void
func _on_void_area_body_entered(body):
	if body.is_in_group("player"):
		print("🚨 Player fell into void! Respawning...")
		body._on_player_died()
	else:
		print("❌ Warning: Non-player object entered VoidArea!")

# 🏁 Handle checkpoint reach
func _on_checkpoint_reached(body):
	if body.is_in_group("player"):
		var checkpoint = body.get_parent()  # Get the checkpoint node

		# ✅ Debug: Print checkpoint children
		print("🔍 Checkpoint Children:", checkpoint.get_children())

		# ✅ Use find_child to find the marker properly
		var spawn_marker = checkpoint.find_child("Spawnpoint", true, false)

		if spawn_marker:
			body.spawn_point = spawn_marker  # ✅ Set spawn point
			print("✅ Checkpoint reached! New spawn point:", spawn_marker.global_position)
		else:
			print("❌ ERROR: 'Spawnpoint' is missing inside the Checkpoint!")
