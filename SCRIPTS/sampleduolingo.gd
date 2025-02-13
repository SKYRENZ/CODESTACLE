extends Node2D

signal quiz_completed

var questions = [
	# Question 1
	{
		"question": "What keyword is used to declare a constant variable in JavaScript?",
		"answers": ["var", "let", "const", "int"],
		"correct": "const"  # Correct answer as a string
	},
	# Question 2
	{
		"question": "Which of the following is a string data type?",
		"answers": ["42", "true", "\"Hello\"", "3.14"],
		"correct": "\"Hello\""
	},
	# Question 3
	{
		"question": "How do you declare a variable in JavaScript?",
		"answers": ["declare myVariable;", "myVariable;", "let myVariable;", "var myVariable = 10;"],
		"correct": "var myVariable = 10;"
	}
]

var current_question_index = 0
var correct_answer: String  # Stores the current question's correct answer

func _ready():
	load_question(current_question_index)
	# Connect buttons (Godot 4 syntax)
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button.pressed.connect(_on_button_pressed.bind(0))
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button2.pressed.connect(_on_button_pressed.bind(1))
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button3.pressed.connect(_on_button_pressed.bind(2))
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button4.pressed.connect(_on_button_pressed.bind(3))

# Load a question and reset UI
func load_question(index):
	reset_button_colors()  # Reset colors before loading new question
	var question_data = questions[index]
	$CanvasLayer/TextureRect/Control/Label.text = question_data["question"]
	correct_answer = question_data["correct"]
	
	# Update button texts with current answers
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button.text = question_data["answers"][0]
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button2.text = question_data["answers"][1]
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button3.text = question_data["answers"][2]
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button4.text = question_data["answers"][3]

# Reset all buttons to default color
func reset_button_colors():
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button.modulate = Color.WHITE
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button2.modulate = Color.WHITE
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button3.modulate = Color.WHITE
	$CanvasLayer/TextureRect/Control/VBoxContainer/Button4.modulate = Color.WHITE

# Handle button presses (now using button index)
func _on_button_pressed(button_index):
	var selected_answer = ""
	# Get the text of the pressed button based on its index
	match button_index:
		0: selected_answer = $CanvasLayer/TextureRect/Control/VBoxContainer/Button.text
		1: selected_answer = $CanvasLayer/TextureRect/Control/VBoxContainer/Button2.text
		2: selected_answer = $CanvasLayer/TextureRect/Control/VBoxContainer/Button3.text
		3: selected_answer = $CanvasLayer/TextureRect/Control/VBoxContainer/Button4.text

	# Highlight correct/incorrect answers
	if selected_answer == correct_answer:
		print("Correct!")
		# Turn correct button green
		match button_index:
			0: $CanvasLayer/TextureRect/Control/VBoxContainer/Button.modulate = Color.GREEN
			1: $CanvasLayer/TextureRect/Control/VBoxContainer/Button2.modulate = Color.GREEN
			2: $CanvasLayer/TextureRect/Control/VBoxContainer/Button3.modulate = Color.GREEN
			3: $CanvasLayer/TextureRect/Control/VBoxContainer/Button4.modulate = Color.GREEN
		# Move to next question after a short delay
		await get_tree().create_timer(1.0).timeout
		current_question_index += 1
		if current_question_index < questions.size():
			load_question(current_question_index)
		else:
			emit_signal("quiz_completed")
	else:
		print("Incorrect!")
		# Turn incorrect button red
		match button_index:
			0: $CanvasLayer/TextureRect/Control/VBoxContainer/Button.modulate = Color.RED
			1: $CanvasLayer/TextureRect/Control/VBoxContainer/Button2.modulate = Color.RED
			2: $CanvasLayer/TextureRect/Control/VBoxContainer/Button3.modulate = Color.RED
			3: $CanvasLayer/TextureRect/Control/VBoxContainer/Button4.modulate = Color.RED
