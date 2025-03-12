extends CanvasLayer

# Define the signal that DoorController is looking for
signal results_closed

# References to managers
var timer_manager = null
var quiz_data_manager = null

# References to UI elements (now using @onready to reference nodes in the scene)
@onready var panel: Panel = $ColorRect/Panel
@onready var title_label: Label = $"ColorRect/Floor complete label"
@onready var score_label: Label = $"ColorRect/quiz score/quiz percentage"
@onready var time_label: Label = $"ColorRect/floor time/floor time timestamp"
@onready var continue_button: Button = $ColorRect/Button

func _ready():
	# Get references to managers
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	quiz_data_manager = get_node_or_null("/root/QuizDataManager")
	
	# Hide the panel until needed
	panel.visible = false
	
	# Connect button signal
	continue_button.connect("pressed", Callable(self, "_on_continue_pressed"))

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
		score_label.text = str(score_percent) + "%"  # Update the quiz percentage container
	else:
		score_label.text = "No Quiz Data Available"
	
	# Update completion time
	if timer_manager and timer_manager.current_floor == floor_number:
		var elapsed_time = timer_manager.stop_timer()
		time_label.text = timer_manager.format_time(elapsed_time)  # Update the floor time timestamp container
		
		# Save the times
		timer_manager.save_times()
	else:
		time_label.text = "Not available"
	
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
