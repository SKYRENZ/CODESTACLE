extends CanvasLayer

# Define the signal that DoorController is looking for
signal results_closed

# References to managers
var timer_manager = null
var quiz_data_manager = null

# Add this debug function
func _enter_tree():
	print("ResultsPanel instance created")

# References to UI elements (now using @onready to reference nodes in the scene)
@onready var panel: Panel = $"ColorRect/Panel"
@onready var title_label: Label = $"ColorRect/Floor complete label"
@onready var score_label: Label = $"ColorRect/quiz score/quiz percentage"
@onready var time_label: Label = $"ColorRect/floor time/floor time timestamp"
@onready var continue_button: Button = $"ColorRect/Button"

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
	
	# Start a coroutine to close the panel after 5 seconds
	call_deferred("close_after_delay")  # Call the function later

# Calculate quiz score from available data
func calculate_quiz_score(floor_number: int) -> int:
	# This is a placeholder - implement your own logic based on how you track quiz scores
	# For example, you might store quiz results in a global variable or a manager
	
	# For demonstration, let's use a random score (replace with your implementation)
	return randi_range(50, 100)
func close_after_delay():
	await get_tree().create_timer(5.0).timeout  # Wait for 5 seconds
	close_panel()
func close_panel():
	print("Closing results panel...")
	
	# Unpause the game
	get_tree().paused = false
	
	# Hide the panel
	panel.visible = false
	
	# Re-enable player movement (if applicable)
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0 and player[0].has_method("set_movement_locked"):
		player[0].set_movement_locked(false)
	
	# Free this instance if it's no longer needed
	queue_free()
