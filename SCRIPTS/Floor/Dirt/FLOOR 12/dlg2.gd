extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "dialogue2"

var dialogue_active = false
var dialogue_triggered = false  # Each instance tracks its own trigger state

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_body_entered(body):
	if body.is_in_group("player") and not dialogue_active and not dialogue_triggered:
		print("Starting dialogue: ", dialogue_start)
		start_dialogue()

func start_dialogue():
	if dialogue_resource != null:
		dialogue_active = true
		dialogue_triggered = true  # This instance is triggered only once
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	else:
		print("Error: dialogue_resource is not assigned!")

func _on_dialogue_started(_resource: DialogueResource):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_movement_locked(true)

func _on_dialogue_ended(_resource: DialogueResource):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.set_movement_locked(false)
	dialogue_active = false  # Reset so new dialogues can trigger
