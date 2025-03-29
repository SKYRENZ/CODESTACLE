extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "signage2"
@export var dia_start: AudioStream = preload("res://BGM/dialouge.mp3")

var dialogue_active = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
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
		
		# Increment sign count in PlayerData
		var player_data = get_node("/root/PlayerData")
		if player_data:
			player_data.increment_signs_read()
	else:
		print("Error: dialogue_resource is not assigned or dialogue already active!")

func _on_dialogue_ended(_resource: DialogueResource):
	AudioPlayer.stop_DIA()
	dialogue_active = false
