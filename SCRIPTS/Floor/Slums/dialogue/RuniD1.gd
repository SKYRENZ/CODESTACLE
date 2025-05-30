extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Runistart"

var dialogue_active = false
var has_been_talked = false

func _ready():
	# Ensure the dialogue_resource is unique for this node
	if dialogue_resource != null:
		dialogue_resource = dialogue_resource.duplicate()
	add_to_group("npc_conversation")
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player") and not dialogue_active:
		DialogueHelper.register_interactable(self)

func _on_body_exited(body):
	if body.is_in_group("player"):
		DialogueHelper.unregister_interactable(self)

func trigger_dialogue():
	if dialogue_resource != null and not dialogue_active:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		dialogue_active = true
	else:
		print("Error: dialogue_resource is not assigned or dialogue already active!")

func _on_dialogue_started(_resource: DialogueResource):
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("set_movement_locked"):
		player.set_movement_locked(true)

func _on_dialogue_ended(resource: DialogueResource):
	if resource != dialogue_resource:
		return
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("set_movement_locked"):
		player.set_movement_locked(false)
	dialogue_active = false
	if is_in_group("npc_conversation") and not has_been_talked:
		ObjectiveManager.increment_npc_interacted()
		has_been_talked = true
