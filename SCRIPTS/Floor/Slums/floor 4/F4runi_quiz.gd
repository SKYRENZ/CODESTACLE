extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Runiquiz"
@export var quiz_scene: PackedScene  # Reference to your quiz scene
@export var floor_number: int = 4     # Which floor's quiz to show

var dialogue_active = false
var input_blocked = true  # Prevents input from affecting dialogue at start
var quiz_shown = false

# Stores a reference to the active dialogue balloon
var active_balloon = null

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	await get_tree().create_timer(0.5).timeout  # Delay input activation
	input_blocked = false  # Now input can be used, but only inside the area

func _on_body_entered(body):
	if body.is_in_group("player") and not dialogue_active and not input_blocked and not quiz_shown:
		if dialogue_resource != null:
			# Start dialogue and get reference to the balloon
			dialogue_active = true
			start_dialogue()
		else:
			print("Error: dialogue_resource is not assigned!")

func _on_body_exited(body):
	if body.is_in_group("player"):
		dialogue_active = false

func start_dialogue():
	# Use a custom method to show dialogue and track its completion
	var balloon = DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	
	# If the balloon was created and has a "dialogue_ended" signal
	if balloon and balloon.has_signal("dialogue_ended"):
		# Connect to the balloon's completion signal
		if not balloon.is_connected("dialogue_ended", Callable(self, "_on_dialogue_ended")):
			balloon.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
		active_balloon = balloon
	elif balloon and balloon.has_signal("tree_exited"):
		# Alternative: connect to tree_exited signal (when balloon is removed from scene)
		if not balloon.is_connected("tree_exited", Callable(self, "_on_dialogue_ended")):
			balloon.connect("tree_exited", Callable(self, "_on_dialogue_ended"))
		active_balloon = balloon
	else:
		# Fallback method: poll for dialogue completion
		print("Using fallback dialogue completion detection")
		active_balloon = balloon

# This function is called when dialogue ends
func _on_dialogue_ended():
	print("Dialogue ended, launching quiz...")
	dialogue_active = false
	
	# Small delay before showing quiz
	await get_tree().create_timer(0.5).timeout
	
	if not quiz_shown:
		quiz_shown = true
		show_quiz()

func _process(delta):
	# Fallback method if signals don't work: check if active_balloon is no longer in tree
	if active_balloon and dialogue_active and not is_instance_valid(active_balloon):
		active_balloon = null
		print("Detected dialogue completion through instance check")
		dialogue_active = false
		
		# Make sure to add a delay
		await get_tree().create_timer(0.5).timeout
		
		if not quiz_shown:
			quiz_shown = true
			show_quiz()

func show_quiz():
	# Show the quiz
	if quiz_scene != null:
		var quiz_instance = quiz_scene.instantiate()
		
		# Set the floor number for this quiz
		if quiz_instance.has_method("set_floor"):
			quiz_instance.set_floor(floor_number)
			
		# Add to the game's UI layer or canvas layer
		get_tree().root.add_child(quiz_instance)
	else:
		print("Error: quiz_scene is not assigned!")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and dialogue_active:  # Space by default
		get_viewport().set_input_as_handled()  # Stops input from affecting other parts of the game
