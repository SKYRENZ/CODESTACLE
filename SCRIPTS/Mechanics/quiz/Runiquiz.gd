extends Control

# Quiz data reference
var quiz_data_manager = null
var current_floor = 1  # Default floor
var quiz_data = []     # Will be populated from QuizDataManager

# Quiz variables
var current_question = 0
var score = 0
var quiz_completed = false

# UI References
var question_label: Label
var option_buttons = []
var background_rect: ColorRect
var content_rect: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get references to UI elements
	background_rect = $CanvasLayer/ColorRect2
	content_rect = $CanvasLayer/ColorRect2/ColorRect
	question_label = $CanvasLayer/ColorRect2/ColorRect/Panel/Label
	option_buttons = [
		$CanvasLayer/ColorRect2/ColorRect/VBoxContainer/A,
		$CanvasLayer/ColorRect2/ColorRect/VBoxContainer/B,
		$CanvasLayer/ColorRect2/ColorRect/VBoxContainer/C,
		$CanvasLayer/ColorRect2/ColorRect/VBoxContainer/D
	]
	
	# Connect button signals
	for i in range(option_buttons.size()):
		option_buttons[i].connect("pressed", Callable(self, "_on_option_pressed").bind(i))
	
	# All buttons should be visible for 4-option quiz
	for button in option_buttons:
		button.visible = true
	
	# Resize the quiz to not take up the full screen
	resize_quiz()
	
	# Load quiz data
	load_quiz_data()
	
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0:
		# Lock player movement
		disable_player_movement(player[0])
		
	# Display the first question
	display_question()

# Set the floor number for this quiz instance
func set_floor(floor_number: int) -> void:
	current_floor = floor_number
	# If the quiz is already instantiated, reload the data
	if quiz_data_manager != null:
		load_quiz_data()

# Load quiz data from the QuizDataManager
func load_quiz_data() -> void:
	# Check if QuizDataManager singleton exists, if not create it
	if not quiz_data_manager:
		# First, check if it exists as a singleton
		if Engine.has_singleton("QuizDataManager"):
			quiz_data_manager = Engine.get_singleton("QuizDataManager")
		else:
			# Try to find it in the scene tree
			quiz_data_manager = get_node_or_null("/root/QuizDataManager")
			
			# If still not found, load it as a script
			if not quiz_data_manager:
				var quiz_manager_script = load("res://path_to_your_script/QuizDataManager.gd")
				quiz_data_manager = quiz_manager_script.new()
				get_tree().root.call_deferred("add_child", quiz_data_manager)
				
	# Get the quiz data for the current floor
	quiz_data = quiz_data_manager.get_quiz_data(current_floor)
	
	# Reset quiz state
	current_question = 0
	score = 0
	quiz_completed = false

# Disables player movement
func disable_player_movement(player_node) -> void:
	# This is a custom method to disable the player's movement
	# You can modify this to fit your player controller
	if player_node.has_method("set_movement_locked"):
		player_node.set_movement_locked(true)

# Enables player movement
func enable_player_movement(player_node) -> void:
	# This is a custom method to enable the player's movement
	if player_node.has_method("set_movement_locked"):
		player_node.set_movement_locked(false)
		
# Resize the quiz to be smaller than the full screen
func resize_quiz() -> void:
	# Get screen size
	var screen_size = get_viewport_rect().size
	
	# Set quiz size to be 80% of screen width and 70% of screen height
	var quiz_width = screen_size.x * 0.8
	var quiz_height = screen_size.y * 0.7
	
	# Center the quiz on screen
	var quiz_pos_x = (screen_size.x - quiz_width) / 2
	var quiz_pos_y = (screen_size.y - quiz_height) / 2
	
	# Apply sizes and positions
	background_rect.size = Vector2(quiz_width, quiz_height)
	background_rect.position = Vector2(quiz_pos_x, quiz_pos_y)
	
	# Adjust the content rect to fit within the background with a small margin
	content_rect.size = Vector2(quiz_width - 40, quiz_height - 40)
	content_rect.position = Vector2(20, 20)
	
	# Adjust the position of the VBoxContainer for options
	var vbox = $CanvasLayer/ColorRect2/ColorRect/VBoxContainer
	vbox.position.x = (content_rect.size.x - vbox.size.x) / 2
	vbox.position.y = content_rect.size.y * 0.50  # Position it at 55% of content height
	
	# Adjust the panel size and position
	var panel = $CanvasLayer/ColorRect2/ColorRect/Panel
	panel.size.x = content_rect.size.x - 40
	panel.size.y = content_rect.size.y * 0.4
	panel.position.x = 20
	panel.position.y = 20
	
	# Adjust Runi sprite position and scale
	var runi_sprite = $CanvasLayer/ColorRect2/ColorRect/RuniTheAllKnowing
	runi_sprite.position.x = 70
	runi_sprite.position.y = content_rect.size.y - 100
	runi_sprite.scale = Vector2(0.35, 0.35)  # Smaller scale

# Displays the current question and its options
func display_question() -> void:
	if current_question < quiz_data.size():
		var question_data = quiz_data[current_question]
		
		# Set the question text
		question_label.text = question_data["question"]
		
		# Set option texts
		for i in range(question_data["options"].size()):
			option_buttons[i].text = str(i + 1) + ". " + question_data["options"][i]
	else:
		# Quiz completed
		show_final_score()

# Handle option selection
func _on_option_pressed(option_index: int) -> void:
	if quiz_completed:
		return
		
	var current_data = quiz_data[current_question]
	
	# Check if answer is correct
	if option_index == current_data["correct_answer"]:
		score += 1
		# Visual feedback (optional)
		option_buttons[option_index].modulate = Color(0, 1, 0)  # Green for correct
	else:
		# Visual feedback (optional)
		option_buttons[option_index].modulate = Color(1, 0, 0)  # Red for incorrect
		option_buttons[current_data["correct_answer"]].modulate = Color(0, 1, 0)  # Show correct answer
	
	# Wait a moment before moving to next question
	await get_tree().create_timer(1.0).timeout
	reset_button_colors()
	
	# Move to next question
	current_question += 1
	if current_question < quiz_data.size():
		display_question()
	else:
		show_final_score()

# Reset button colors after feedback
func reset_button_colors() -> void:
	for button in option_buttons:
		button.modulate = Color(1, 1, 1)  # Reset to default color

# Show the final score when quiz is complete
func show_final_score() -> void:
	quiz_completed = true
	
	# Hide options
	for button in option_buttons:
		button.visible = false
	
	# Show final score
	question_label.text = "Quiz Completed!\n\nYour Score: " + str(score) + "/" + str(quiz_data.size())
	
	# Add continue button at the bottom center of the screen
	var continue_button = Button.new()
	continue_button.text = "Continue"
	continue_button.custom_minimum_size = Vector2(200, 70)
	
	# Calculate bottom center position
	var rect_size = content_rect.size
	var button_pos_x = (rect_size.x / 2) - (continue_button.custom_minimum_size.x / 2)
	var button_pos_y = rect_size.y - 100  # 100 pixels from the bottom
	
	continue_button.connect("pressed", Callable(self, "_on_continue_pressed"))
	content_rect.add_child(continue_button)
	continue_button.position = Vector2(button_pos_x, button_pos_y)

# Handle continue button press - close the screen
func _on_continue_pressed() -> void:
	# Find the player node
	var player = get_tree().get_nodes_in_group("player")
	if player.size() > 0:
		# Re-enable player movement
		enable_player_movement(player[0])
	
	# Close the quiz
	queue_free()
