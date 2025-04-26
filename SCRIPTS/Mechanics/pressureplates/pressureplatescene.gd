# PRESSUREPLATESCENE.gd
extends Node2D

@export var wall_path: NodePath  # Allow selecting the wall node in the Inspector
@onready var wall = null  # Reference to the selected wall node

@onready var question_label = $question  # Label for the question
@onready var option_labels = [
	$pressureplate/option1,
	$pressureplate2/option2,
	$pressureplate3/option3
]  # Labels for the options

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
var wall_animation_playing = false  # Prevent multiple animations from playing at the same time

func _ready():
	print("Setting up signal connections...")
	_load_question()

	# Dynamically get the wall node from the wall_path
	if wall_path != null:
		wall = get_node(wall_path)
		print("Wall node selected: %s" % wall.name)
	else:
		print("⚠️ No wall node selected in the Inspector!")

	# Connect pressure plate signals
	$pressureplate.connect("plate_activated", Callable(self, "_on_plate_activated"))
	$pressureplate2.connect("plate_activated", Callable(self, "_on_plate_activated"))
	$pressureplate3.connect("plate_activated", Callable(self, "_on_plate_activated"))
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
	if wall_animation_playing:
		print("Wall animation is already playing. Ignoring duplicate request.")
		return  # Prevent multiple animations from playing at the same time

	print("Removing wall...")
	wall_animation_playing = true  # Mark the animation as playing

	# Disable collision by modifying the collision layer and mask
	if wall and wall.has_node("staticwall2"):
		var static_body = wall.get_node("staticwall2")  # Reference to the StaticBody2D
		if static_body:
			static_body.collision_layer = 0  # Remove the object from all collision layers
			static_body.collision_mask = 0  # Prevent the object from detecting collisions
			print("Collision disabled for staticwall2.")
		else:
			print("⚠️ staticwall2 node found but is null.")
	else:
		print("⚠️ staticwall2 node not found in wall.")

	# Play wall animation once
	if wall and wall.has_method("play"):  # Ensure the wall node has the play method
		print("DIRTWALLANI2 found. Playing 'wallanimation'...")
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
		print("⚠️ DIRTWALLANI2 does not have a 'play' method or is not an AnimatedSprite2D.")

	wall_animation_playing = false  # Mark the animation as finished
	print("Wall removal process completed.")

func _vibrate_player():
	print("Player vibrates!")
