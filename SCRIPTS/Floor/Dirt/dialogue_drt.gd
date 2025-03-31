extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "signage4"

var dialogue_active = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	# Connect to DialogueManager signals
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_body_entered(body):
	if body.is_in_group("player") and not dialogue_active:
		start_dialogue()

func _on_body_exited(body):
	if body.is_in_group("player"):
		dialogue_active = false  # Reset when player leaves area

func start_dialogue():
	if dialogue_resource != null:
		dialogue_active = true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	else:
		print("Error: dialogue_resource is not assigned!")

func _on_dialogue_started(_resource: DialogueResource):
	# Lock player movement when dialogue starts
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_movement_locked(true)

func _on_dialogue_ended(_resource: DialogueResource):
	# Unlock player movement when dialogue ends
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_movement_locked(false)
		dialogue_active = false  # Reset dialogue state
