extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "signage1"
@export var dia_start: AudioStream = preload("res://BGM/dialouge.mp3")  # Preload your dialogue audio
@export var use_letterbox: bool = true  # Toggle to enable/disable letterbox for this signage

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
	DialogueManager.dialogue_started.connect(Callable(self, "_on_dialogue_started"))
	DialogueManager.dialogue_ended.connect(Callable(self, "_on_dialogue_ended"))

func _on_body_entered(body):
	if body.is_in_group("player") and not dialogue_active:
		DialogueHelper.register_interactable(self)

func _on_body_exited(body):
	if body.is_in_group("player"):
		DialogueHelper.unregister_interactable(self)
		dialogue_active = false

func trigger_dialogue():
	if dialogue_resource != null and not dialogue_active:
		if use_letterbox:
			# Start the letterbox animation if enabled
			var letterbox = get_node("/root/LetterBox")  # Correct way to access it
			if letterbox:
				letterbox.dialogue_resource = dialogue_resource  # Pass dialogue resource
				letterbox.dialogue_start = dialogue_start  # Pass dialogue start
				letterbox.dia_start = dia_start  # Pass audio stream
				letterbox.should_show_dialogue = true  # Set flag to show dialogue after hide animation
				letterbox.play_letterbox_in()  # Start the letterbox animation
			else:
				print("LetterBox node not found.")
		else:
			# If letterbox is not used, show the dialogue immediately
			show_dialogue_and_play_audio()

		dialogue_active = true
	else:
		print("Error: dialogue_resource is not assigned or dialogue already active!")

func show_dialogue_and_play_audio():
	# Show the dialogue and play audio immediately without letterbox
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	AudioPlayer.play_DIA(dia_start, -12.0)

func _on_dialogue_started():
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
		ObjectiveManager.increment_signage_read()
		has_been_read = true
	else:
		print("Signage: Already read or not in signage_conversation")

	AudioPlayer.stop_DIA()  # Stop the audio when dialogue ends
	dialogue_active = false

	# Hide letterbox if enabled
	if use_letterbox:
		var letterbox = get_node("/root/LetterBox")  # Correct node path checking
		if letterbox:
			letterbox.play_letterbox_out()
		else:
			print("LetterBox node not found.")
