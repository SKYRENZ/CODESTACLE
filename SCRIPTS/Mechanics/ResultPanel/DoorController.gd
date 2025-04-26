extends Area2D

# Configuration options
@export var next_floor_path: String = ""  # Direct path to next floor scene
@export var floor_number: int = 1  # Current floor number
@export_file("*.tscn") var results_panel_path: String = "res://SCENES/Mechanics/resultpanel/results_panel.tscn"

var player_in_area = false
var timer_manager = null

func _ready():
	# Debug tracking
	print("DoorController %d initialized. Next floor: %s" % [floor_number, next_floor_path])
	
	# Get reference to timer manager
	timer_manager = get_node_or_null("res://SCRIPTS/Mechanics/timer/FloorTimerManager.gd")
	
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Validate results panel path
	if !ResourceLoader.exists(results_panel_path):
		printerr("Results panel path invalid: %s" % results_panel_path)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("Player entered door area (Floor %d)" % floor_number)

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		print("Player left door area")

func _unhandled_input(event):
	if event.is_action_pressed("interact") and player_in_area:
		print("Interact pressed at door on Floor %d" % floor_number)
		handle_floor_completion()

func handle_floor_completion():
	print("Handling floor completion...")

	# Stop and save timer
	if timer_manager and timer_manager.timer_running:
		var elapsed_time = timer_manager.stop_timer()
		print("Floor %d completed in %s" % [floor_number, timer_manager.format_time(elapsed_time)])
		timer_manager.save_times()
	
	# Verify path exists
	print("Results panel path: ", results_panel_path)
	print("Path exists: ", ResourceLoader.exists(results_panel_path))
	
	# Show results panel
	if ResourceLoader.exists(results_panel_path):
		print("Loading results panel scene...")
		var results_scene = load(results_panel_path)
		print("Instantiating results panel...")
		var results_instance = results_scene.instantiate()
		
		# Ensure panel and its UI are properly visible
		results_instance.process_mode = Node.PROCESS_MODE_ALWAYS
		
		# Add to scene tree
		get_tree().root.add_child(results_instance)
		print("Results panel added to scene tree")
		
		# Setup the continue button after the panel is ready
		call_deferred("_setup_results_panel", results_instance)
		
		# Show results if method exists
		if results_instance.has_method("show_results"):
			var score = get_player_score()
			print("Showing results with score: %d" % score)
			results_instance.show_results(floor_number, score)
		else:
			printerr("Results panel missing show_results method!")
	else:
		printerr("Results panel scene not found: %s" % results_panel_path)
		# Fall back to direct transition
		transition_to_next_floor(null)

func _setup_results_panel(panel):
	print("Setting up results panel...")

	# Make sure the panel is visible
	if panel.has_node("ColorRect/Panel"):
		panel.get_node("ColorRect/Panel").visible = true
		print("Panel set to visible")
	
	# Connect continue button
	if panel.has_node("ColorRect/Button"):
		var continue_button = panel.get_node("ColorRect/Button")
		continue_button.process_mode = Node.PROCESS_MODE_ALWAYS
		
		# Disconnect any existing connections to avoid duplicates
		if continue_button.is_connected("pressed", Callable(self, "_on_continue_pressed")):
			continue_button.disconnect("pressed", Callable(self, "_on_continue_pressed"))
		
		# Connect new signal
		continue_button.pressed.connect(_on_continue_pressed.bind(panel))
		print("Continue button connected")
	else:
		printerr("Continue button not found in results panel")

func _on_continue_pressed(panel):
	print("Continue button pressed!")

	# Show transition scene before proceeding
	show_transition(panel)

func show_transition(panel):
	print("🚪 Showing transition scene before starting the next floor...")

	# Load the transition scene
	var transition_scene_path = "res://SCENES/Transitions/Transition.tscn"  # Update this path if needed
	if !ResourceLoader.exists(transition_scene_path):
		printerr("❌ Transition scene not found: %s" % transition_scene_path)
		transition_to_next_floor(panel)
		return

	var transition_scene = load(transition_scene_path)
	var transition_instance = transition_scene.instantiate()
	get_tree().root.add_child(transition_instance)

	# Connect the fade_out_finished signal to proceed after the transition
	if transition_instance.has_signal("fade_out_finished"):
		transition_instance.fade_out_finished.connect(Callable(self, "_on_transition_finished").bind(panel))
	else:
		printerr("❌ Transition scene missing fade_out_finished signal!")
		transition_to_next_floor(panel)

func _on_transition_finished(panel):
	print("🚪 Transition finished. Proceeding to next floor...")
	transition_to_next_floor(panel)

func get_player_score() -> int:
	var player_data = get_node_or_null("/root/PlayerData")
	if player_data and player_data.has_method("get_quiz_score"):
		return player_data.get_quiz_score(floor_number)
	print("Quiz score data not available")
	return 0

func transition_to_next_floor(panel):
	print("🚪 Transitioning to next floor: %s" % next_floor_path)

	# Unpause game
	get_tree().paused = false
	
	# Clean up panel if it exists
	if panel:
		panel.queue_free()

	# Change scene if path is valid
	if next_floor_path != "" and ResourceLoader.exists(next_floor_path):
		print("🛠 Changing scene to %s..." % next_floor_path)
		get_tree().change_scene_to_file(next_floor_path)
	else:
		printerr("❌ ERROR: Cannot transition - Invalid or missing scene path")
