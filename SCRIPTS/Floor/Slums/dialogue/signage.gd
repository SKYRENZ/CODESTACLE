extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "signage1"
@export var dia_start: AudioStream = preload("res://BGM/dialouge.mp3")

var dialogue_active = false
var has_been_read = false

func _ready():
	# Ensure the dialogue_resource is unique for this node
	if dialogue_resource != null:
		dialogue_resource = dialogue_resource.duplicate()
	add_to_group("signage_conversation")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	# Connect to DialogueManager signals
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_body_entered(body):
	if body.is_in_group("player") and not dialogue_active:
		DialogueHelper.register_interactable(self)

func _on_body_exited(body):
	if body.is_in_group("player"):
		DialogueHelper.unregister_interactable(self)
		dialogue_active = false

func trigger_dialogue():
	if dialogue_resource != null and not dialogue_active:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		dialogue_active = true
		AudioPlayer.play_DIA(dia_start, -12.0)
	else:
		print("Error: dialogue_resource is not assigned or dialogue already active!")

func _on_dialogue_started(_resource: DialogueResource):
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("set_movement_locked"):
		player.set_movement_locked(true)

func _on_dialogue_ended(resource: DialogueResource):
	if resource != dialogue_resource:
		return
	# Unlock player movement
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("set_movement_locked"):
		print("Signage: Unlocking player movement")
		player.set_movement_locked(false)
	else:
		print("Signage: Player not found or set_movement_locked method missing")
	if is_in_group("signage_conversation") and not has_been_read:
		print("Signage: Incrementing signage read")
	else:
		print("Signage: Already read or not in signage_conversation")  # Debugging
		ObjectiveManager.increment_signage_read()
		has_been_read = true
	AudioPlayer.stop_DIA()
	dialogue_active = false
