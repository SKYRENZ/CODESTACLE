extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "signage1"
@export var dia_start: AudioStream = preload("res://BGM/dialouge.mp3")
@export var use_letterbox: bool = true

@export var pan_distance: float = 500.0  # Distance for panning
@export var pan_speed: float = 200.0  # Speed for panning (units per second)
@export var pan_pause_duration: float = 1.0  # ✅ Pause duration after panning

# Enum definition for camera panning directions
enum PanningDirection { NONE, UP, DOWN, LEFT, RIGHT }

@export var pan_direction: PanningDirection = PanningDirection.RIGHT

var dialogue_active = false
var has_been_read = false

var camera: Camera2D

func _ready():
	if dialogue_resource != null:
		dialogue_resource = dialogue_resource.duplicate()

	add_to_group("signage_conversation")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	DialogueManager.dialogue_started.connect(Callable(self, "_on_dialogue_started"))
	DialogueManager.dialogue_ended.connect(Callable(self, "_on_dialogue_ended"))

	camera = get_node_or_null("/root/Camera2D")
	if camera == null:
		print("ERROR: Camera2D node not found!")

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
			var letterbox = get_node("/root/LetterBox")
			if letterbox:
				letterbox.dialogue_resource = dialogue_resource
				letterbox.dialogue_start = dialogue_start
				letterbox.dia_start = dia_start
				letterbox.should_show_dialogue = true
				letterbox.pan_distance = pan_distance
				letterbox.pan_speed = pan_speed
				letterbox.pan_direction = get_pan_direction_string(pan_direction)
				letterbox.pan_pause_duration = pan_pause_duration  # ✅ Include pause duration
				letterbox.play_letterbox_in()
			else:
				print("ERROR: LetterBox node not found.")
		else:
			show_dialogue_and_play_audio()

		dialogue_active = true
	else:
		print("ERROR: dialogue_resource is not assigned or dialogue already active!")

func show_dialogue_and_play_audio():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	AudioPlayer.play_DIA(dia_start, -12.0)

func _on_dialogue_started():
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("set_movement_locked"):
		player.set_movement_locked(true)

func _on_dialogue_ended(resource: DialogueResource):
	if resource != dialogue_resource:
		return

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

	AudioPlayer.stop_DIA()
	dialogue_active = false

	if use_letterbox:
		var letterbox = get_node("/root/LetterBox")
		if letterbox:
			letterbox.play_letterbox_out()
		else:
			print("ERROR: LetterBox node not found.")

# Converts enum to string for use in LetterBox
func get_pan_direction_string(direction: PanningDirection) -> String:
	match direction:
		PanningDirection.NONE:
			return ""
		PanningDirection.UP:
			return "up"
		PanningDirection.DOWN:
			return "down"
		PanningDirection.LEFT:
			return "left"
		PanningDirection.RIGHT:
			return "right"
		_:
			print("ERROR: Invalid panning direction!")
			return ""
