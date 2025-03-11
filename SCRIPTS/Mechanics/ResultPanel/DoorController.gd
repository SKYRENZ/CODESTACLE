extends Area2D

@export var next_floor: PackedScene  # The scene to load when player proceeds
@export var floor_number: int = 1     # Current floor number
@export var results_panel_scene: PackedScene  # Reference to results panel scene

var player_in_area = false

func _ready():
	print_debug("DoorController: _ready called for floor " + str(floor_number))
	
	# Check if next_floor is set
	if next_floor:
		print_debug("DoorController: next_floor is assigned to: " + str(next_floor.resource_path))
	else:
		print_debug("WARNING: next_floor is NOT assigned!")
	
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print_debug("DoorController: Player entered area")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		print_debug("DoorController: Player exited area")

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_in_area:
		print_debug("DoorController: Interact button pressed while in area")
		get_viewport().set_input_as_handled()
		show_results_panel()

func show_results_panel():
	print_debug("DoorController: Showing results panel")
	
	# Check if results_panel_scene is assigned
	if results_panel_scene == null:
		print_debug("ERROR: results_panel_scene is null! Assign it in the Inspector.")
		return
	
	# Instance the results panel
	var results_instance = results_panel_scene.instantiate()
	get_tree().root.add_child(results_instance)
	
	print_debug("DoorController: Results panel instantiated")
	
	# Calculate quiz score (simple example)
	var quiz_score = 85
	
	# Connect to the closed signal
	if results_instance.has_signal("results_closed"):
		print_debug("DoorController: Connecting results_closed signal")
		results_instance.connect("results_closed", Callable(self, "_on_results_closed"))
	else:
		print_debug("ERROR: Results panel missing results_closed signal!")
	
	# Show the results
	if results_instance.has_method("show_results"):
		print_debug("DoorController: Calling show_results")
		results_instance.show_results(floor_number, quiz_score)
	else:
		print_debug("ERROR: Results panel missing show_results method!")

func _on_results_closed():
	print_debug("DoorController: Results closed signal RECEIVED! ===========================")
	
	# Transition to the next floor when player closes results
	if next_floor:
		print_debug("DoorController: Changing to next floor scene: " + str(next_floor.resource_path))
		# Simple direct scene change
		get_tree().change_scene_to_packed(next_floor)
	else:
		print_debug("ERROR: next_floor is not assigned! Cannot proceed.")
