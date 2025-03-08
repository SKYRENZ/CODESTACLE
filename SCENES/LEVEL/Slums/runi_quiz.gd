extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Runiend"

var dialogue_active = false
var input_blocked = true  # Prevents input from affecting dialogue at start
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	await get_tree().create_timer(0.5).timeout  # Delay input activation
	input_blocked = false  # Now input can be used, but only inside the area

func _on_body_entered(body):
	if body.is_in_group("player") and not dialogue_active and not input_blocked:
		if dialogue_resource != null:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
			dialogue_active = true
		else:
			print("Error: dialogue_resource is not assigned!")

func _on_body_exited(body):
	if body.is_in_group("player"):
		dialogue_active = false  # Reset when player leaves area

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):  # Space by default
		get_viewport().set_input_as_handled()  # Stops input from affecting other parts of the game
