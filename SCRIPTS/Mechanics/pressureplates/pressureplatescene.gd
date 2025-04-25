# PRESSUREPLATESCENE.gd
extends Node2D

@onready var question_label = $question  # Label for the question
@onready var option_labels = [
	$pressureplate/option1,
	$pressureplate2/option2,
	$pressureplate3/option3
]  # Labels for the options
@onready var wall = $DIRTWALLANI  # Reference to the dirt wall node

# List of questions and answers
var questions = [
	{
		"question": "Which operator is used to return the remainder of a division in JavaScript?",
		"options": ["A: /", "B: %", "C: *"],
		"correct": "B"
	},
	{
		"question": "Which operator checks if two values are equal in JavaScript?",
		"options": ["A: =", "B: ==", "C: ==="],
		"correct": "B"
	},
	{
		"question": "Which operator is used to combine multiple conditions in JavaScript?",
		"options": ["A: &&", "B: ||", "C: !"],
		"correct": "A"
	}
]

var current_question_index = 0  # Track the current question

func _ready():
	print("Setting up signal connections...")
	_load_question()
	
	# Connect pressure plate signals
	$pressureplate.connect("plate_activated", Callable(self, "_on_plate_activated").bind("A"))
	$pressureplate2.connect("plate_activated", Callable(self, "_on_plate_activated").bind("B"))
	$pressureplate3.connect("plate_activated", Callable(self, "_on_plate_activated").bind("C"))
	print("Signals connected successfully.")

func _load_question():
	# Load the current question and options
	var current_question = questions[current_question_index]
	print("Loading question: %s" % current_question["question"])
	question_label.text = current_question["question"]
	
	# Update the text for each option label
	for i in range(option_labels.size()):
		option_labels[i].text = current_question["options"][i]
		print("Option %d: %s" % [i + 1, current_question["options"][i]])

func _on_plate_activated(answer):
	print("Signal received in PRESSUREPLATESCENE with answer: %s" % answer)
	var current_question = questions[current_question_index]
	print("Correct answer: %s" % current_question["correct"])
	
	if answer == current_question["correct"]:
		print("✅ Correct! The wall is removed!")
		_remove_wall()
	else:
		print("❌ Wrong answer! Try again!")
		_vibrate_player()

func _remove_wall():
	print("Removing wall...")

	# Disable collision
	if wall.has_node("staticwall2/collisionwall"):
		var collision_shape = wall.get_node("staticwall2/collisionwall")
		collision_shape.disabled = true  # Disable collision
		print("Collision disabled.")
	else:
		print("CollisionShape2D not found in wall.")

	# Play wall animation
	if wall is AnimatedSprite2D:
		print("DIRTWALLANI found. Playing 'wallanimation'...")
		wall.play("wallanimation")  # Play the wall animation
		print("Wallanimation is playing.")
		
		# Wait for the animation to finish
		var sprite_frames = wall.sprite_frames
		var frame_count = sprite_frames.get_frame_count("wallanimation")  # Should be 4 frames
		var animation_speed = wall.speed_scale  # Speed scale of the animation
		var animation_duration = frame_count / animation_speed  # Total duration of the animation
		print("Wallanimation duration: %f seconds" % animation_duration)
		
		await get_tree().create_timer(animation_duration).timeout
		wall.play("stop")  # Play the stop animation
		print("Wall animation stopped.")
	else:
		print("DIRTWALLANI is not an AnimatedSprite2D.")

	# Hide the wall after the animation
	wall.visible = false
	print("Wall visibility set to false.")

func _vibrate_player():
	print("Player vibrates!")
