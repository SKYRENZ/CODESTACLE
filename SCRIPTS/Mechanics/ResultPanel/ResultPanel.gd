extends CanvasLayer

# Define the signal that DoorController is looking for
signal results_closed

# References to managers
var timer_manager = null
var quiz_data_manager = null

# References to UI elements
var panel
var title_label
var score_label
var time_label
var continue_button

# Create UI elements programmatically
func _ready():
	# Get references to managers
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	quiz_data_manager = get_node_or_null("/root/QuizDataManager")
	
	# Create panel
	create_ui_elements()
	
	# Hide until needed
	panel.visible = false
	
	# Connect button signal
	continue_button.connect("pressed", Callable(self, "_on_continue_pressed"))

# Create all UI elements
func create_ui_elements():
	# Main panel
	panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.set_size(Vector2(500, 350))
	add_child(panel)
	
	# Title
	title_label = Label.new()
	title_label.text = "Floor Complete!"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.set_position(Vector2(0, 30))
	title_label.set_size(Vector2(500, 40))
	title_label.add_theme_font_size_override("font_size", 28)
	panel.add_child(title_label)
	
	# Score result
	score_label = Label.new()
	score_label.text = "Quiz Score: 0%"
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.set_position(Vector2(0, 120))
	score_label.set_size(Vector2(500, 30))
	score_label.add_theme_font_size_override("font_size", 22)
	panel.add_child(score_label)
	
	# Time result
	time_label = Label.new()
	time_label.text = "Floor Time: 00:00.00"
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_label.set_position(Vector2(0, 170))
	time_label.set_size(Vector2(500, 30))
	time_label.add_theme_font_size_override("font_size", 22)
	panel.add_child(time_label)
	
	# Continue button
	continue_button = Button.new()
	continue_button.text = "Continue"
	continue_button.set_position(Vector2(175, 250))
	continue_button.set_size(Vector2(150, 60))
	panel.add_child(continue_button)

# Show the results panel with calculated data
func show_results(floor_number: int, quiz_score: int = -1):
	# If we don't have a specific quiz score, try to calculate from player progress
	if quiz_score == -1 and quiz_data_manager != null:
		quiz_score = calculate_quiz_score(floor_number)
	
	# Update floor name in title
	title_label.text = "Floor " + str(floor_number) + " Complete!"
	
	# Update quiz score
	var score_percent = quiz_score
	if score_percent > 0:
		score_label.text = "Quiz Score: " + str(score_percent) + "%"
	else:
		score_label.text = "No Quiz Data Available"
	
	# Update completion time
	if timer_manager and timer_manager.current_floor == floor_number:
		var elapsed_time = timer_manager.stop_timer()
		time_label.text = "Floor Time: " + timer_manager.format_time(elapsed_time)
		
		# Save the times
		timer_manager.save_times()
	else:
		time_label.text = "Floor Time: Not available"
	
	# Show the panel
	panel.visible = true
	
	# Pause the game (optional)
	get_tree().paused = true
	
	# Disable player movement
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0 and player[0].has_method("set_movement_locked"):
		player[0].set_movement_locked(true)

# Calculate quiz score from available data
func calculate_quiz_score(floor_number: int) -> int:
	# This is a placeholder - implement your own logic based on how you track quiz scores
	# For example, you might store quiz results in a global variable or a manager
	
	# For demonstration, let's use a random score (replace with your implementation)
	return randi_range(50, 100)

# Handle continue button press
func _on_continue_pressed():
	# Hide the panel
	panel.visible = false
	
	# Unpause the game
	get_tree().paused = false
	
	# Re-enable player movement
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0 and player[0].has_method("set_movement_locked"):
		player[0].set_movement_locked(false)
	
	# Signal that the player can now proceed
	emit_signal("results_closed")
	
	# Clean up - remove the panel from the scene
	queue_free()
