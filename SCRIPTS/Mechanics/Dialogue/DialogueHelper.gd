extends Node

signal interaction_available(interactable)
signal interaction_unavailable(interactable)

var current_interactable = null
var is_audio_playing = false  # To track the audio state

@export var dia_start: AudioStream = preload("res://BGM/dialouge.mp3")  # Audio file

func _ready():
	# Connect to input processing for the global interaction key
	process_mode = Node.PROCESS_MODE_ALWAYS # To work even when game is paused
	
	# Connect to dialogue ended signal
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _unhandled_input(event):
	if event.is_action_pressed("interact") and current_interactable != null:
		if current_interactable.has_method("trigger_dialogue"):
			current_interactable.trigger_dialogue()
			get_viewport().set_input_as_handled()

# Called by interactable when player enters its area
func register_interactable(interactable):
	if current_interactable == null:
		current_interactable = interactable
		emit_signal("interaction_available", interactable)

# Called by interactable when player exits its area
func unregister_interactable(interactable):
	if current_interactable == interactable:
		current_interactable = null
		emit_signal("interaction_unavailable", interactable)

# This function is called when dialogue starts
func start_dialogue_audio():
	if !is_audio_playing:
		AudioPlayer.play_DIA(dia_start, -12.0)
		is_audio_playing = true  # Set flag that audio is playing

# This function is called when the dialogue ends
func _on_dialogue_ended(_resource: DialogueResource):
	# Stop the audio when dialogue ends
	if is_audio_playing:
		AudioPlayer.stop_DIA()
		is_audio_playing = false  # Reset the audio flag
