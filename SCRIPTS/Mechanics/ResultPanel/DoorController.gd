extends Area2D

@export var next_floor: PackedScene
@export var floor_number: int = 1
@export var results_panel_scene: PackedScene

var player_in_area = false

func _ready():
	# Debug tracking
	print("DoorController %d initialized. Next floor: %s" % [
		floor_number, 
		next_floor.resource_path if next_floor else "NULL"
	])
	
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("Player ENTERED door area (Floor %d)" % floor_number)

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		print("Player LEFT door area")

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_in_area:
		print("INTERACT pressed on Floor %d" % floor_number)
		show_results_panel()

func show_results_panel():
	print("Attempting to show results panel...")
	var results_instance = results_panel_scene.instantiate()
	get_tree().root.add_child(results_instance)
	
	# Critical signal connection check
	if results_instance.connect("results_closed", Callable(self, "_on_results_closed")) != OK:
		printerr("FAILED to connect results_closed signal!")
	
	if results_instance.has_method("show_results"):
		var score = get_player_score()
		print("Showing results with score: ", score)
		results_instance.show_results(floor_number, score)
	else:
		printerr("Results panel missing show_results method!")

func get_player_score() -> int:
	var player_data = get_node_or_null("/root/PlayerData")
	if player_data:
		return player_data.get_quiz_score(floor_number)
	print("PlayerData not found!")
	return 0

func _on_results_closed():
	print("RESULTS CLOSED SIGNAL RECEIVED")
	if next_floor:
		print("Transitioning to: ", next_floor.resource_path)
		# Ensure scene exists in project files
		if ResourceLoader.exists(next_floor.resource_path):
			get_tree().change_scene_to_packed(next_floor)
		else:
			printerr("Missing scene file: ", next_floor.resource_path)
	else:
		printerr("Next floor scene not assigned!")
