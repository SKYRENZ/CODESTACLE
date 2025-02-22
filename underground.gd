extends Node2D

func _ready():
	var player = get_node("CharacterBody2D")
	if player:
		var spawn_point = get_node("Marker2D")
		if spawn_point:
			player.spawn_point = spawn_point
			print("Spawn point set!")
		else:
			print("Error: Marker2D (SpawnPoint) not found in Underground!")

		var void_area = get_node("VoidArea")
		if void_area:
			void_area.connect("body_entered", _on_void_area_body_entered)  # Connect ONLY here
			print("Void area signal connected!")
		else:
			print("Error: VoidArea not found in Underground!")
	else:
		print("Error: CharacterBody2D (Player) not found in Underground!")

func _on_void_area_body_entered(body):
	print("Body entered VoidArea: ", body)  # Print the entering body
	print("Body's class: ", body.get_class()) # Print the entering body's class

	if body.is_in_group("player"):
		print("Body IS in 'player' group!")
	else:
		print("Body is NOT in 'player' group.")

	if body is Node:
		print("Body IS a Node!")
		if body.get_script():  # Check if the body has a script
			print("Body has a script!")
			if body.has_method("_on_player_died"):  # Ensure the method exists
				body._on_player_died()
			else:
				print("Body does NOT have the '_on_player_died' method!")
		else:
			print("Body does NOT have a script!")
	else:
		print("Body is NOT a Node!")
