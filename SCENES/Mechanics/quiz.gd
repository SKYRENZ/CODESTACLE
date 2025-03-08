extends Control

# Quiz data structure with 4 options per question
var quiz_data = [
	{
		"question": "What is the primary purpose of JavaScript?",
		"options": [
			"To style the appearance of a webpage",
			"To add interactivity and dynamic behavior to a webpage",
			"To define the structure of a webpage",
			"To manage server-side operations"
		],
		"correct_answer": 1  # 0-based index, so option 2
	},
	{
		"question": "Where is JavaScript commonly used?",
		"options": [
			"Only in desktop applications",
			"Primarily in server-side programming",
			"In almost every website to create interactive experiences",
			"Only in mobile applications"
		],
		"correct_answer": 2  # 0-based index, so option 3
	},
	{
		"question": "Which of the following is NOT a common use of JavaScript?",
		"options": [
			"Creating dynamic web applications",
			"Handling server-side logic",
			"Adding animations to webpages",
			"Defining database schemas"
		],
		"correct_answer": 3  # 0-based index, so option 4
	},
	{
		"question": "JavaScript makes the website what?",
		"options": [
			"Load faster",
			"More secure",
			"Come to life",
			"Easier to read by search engines"
		],
		"correct_answer": 2  # 0-based index, so option 3
	}
]

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
	
	# Display the first question
	display_question()

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
	# Close the quiz screen
	queue_free()
