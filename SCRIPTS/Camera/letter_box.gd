extends CanvasLayer

@onready var top_bar = $ColorRectTop
@onready var bottom_bar = $ColorRectBot
@onready var animator = $AnimationPlayer
@onready var signage_label = $Label

@export var pan_direction: String = "right"
@export var pan_distance: float = 500.0
@export var pan_speed: float = 200.0  # <-- NEW: Use speed instead of duration

enum State { IDLE, SHOWING, HIDING }
var state: int = State.IDLE

var should_show_dialogue = false
var dialogue_resource: DialogueResource = null
var dialogue_start: String = ""
var dia_start: AudioStream = null

var was_timer_paused = false
var timer_manager = null
@onready var player = get_tree().get_first_node_in_group("player")
@onready var dialogue_manager = get_node_or_null("/root/DialogueManager")

var is_panning = false
var active_tween: Tween = null
var restarting: bool = false
var pending_pan_back: bool = false

func _ready():
	visible = false
	animator.connect("animation_finished", Callable(self, "_on_animation_finished"))
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	force_reset()

func play_letterbox_in():
	if state != State.IDLE or restarting:
		print("LetterBox is busy or restarting.")
		return

	state = State.SHOWING
	visible = true
	animator.stop()
	animator.play("show")

	if player:
		player.set_movement_locked(true)
	if timer_manager:
		was_timer_paused = timer_manager.get_timer_paused()
		timer_manager.set_timer_paused(true)

func play_letterbox_out():
	if state != State.IDLE or restarting:
		print("LetterBox is busy hiding or restarting.")
		return

	state = State.HIDING
	animator.stop()
	animator.play("hide")

func _on_animation_finished(anim_name: String) -> void:
	if restarting:
		return

	if anim_name == "show" and state == State.SHOWING:
		state = State.IDLE
		if not is_panning:
			if pan_direction.to_lower() == "none":
				play_letterbox_out()
			else:
				_cutscene_camera_pan()
	elif anim_name == "hide" and state == State.HIDING:
		state = State.IDLE
		visible = false

		if player:
			player.set_movement_locked(false)
		if timer_manager and not was_timer_paused:
			timer_manager.set_timer_paused(false)

		if should_show_dialogue and dialogue_resource:
			trigger_dialogue()

func _cutscene_camera_pan():
	if restarting:
		return

	var current_camera = get_viewport().get_camera_2d()
	if not current_camera:
		print("No active camera found!")
		play_letterbox_out()
		return

	is_panning = true
	
	if active_tween and active_tween.is_running():
		active_tween.kill()

	var start_pos = current_camera.global_position
	var end_pos = start_pos

	match pan_direction.to_lower():
		"right": end_pos.x += pan_distance
		"left": end_pos.x -= pan_distance
		"up": end_pos.y -= pan_distance
		"down": end_pos.y += pan_distance
		_:
			print("Invalid pan direction: ", pan_direction)
			is_panning = false
			play_letterbox_out()
			return

	var pan_duration = pan_distance / pan_speed  # <-- DYNAMIC DURATION

	active_tween = create_tween()
	active_tween.tween_property(current_camera, "global_position", end_pos, pan_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	await active_tween.finished

	if not is_instance_valid(current_camera) or restarting:
		return

	_pan_back_to_player(current_camera)

func _pan_back_to_player(current_camera):
	var attempts := 30
	while (not player or not current_camera) and attempts > 0:
		await get_tree().process_frame
		current_camera = get_viewport().get_camera_2d()
		player = get_tree().get_first_node_in_group("player")
		attempts -= 1

	if not player or not current_camera:
		print("Pan aborted: Missing player or camera after waiting.")
		print("I will not go back")
		play_letterbox_out()
		return

	print("I will go back")
	var target_pos = player.global_position
	var return_distance = current_camera.global_position.distance_to(target_pos)
	var return_duration = return_distance / pan_speed  # <-- DYNAMIC RETURN

	if active_tween and active_tween.is_running():
		active_tween.kill()

	active_tween = create_tween()
	active_tween.tween_property(current_camera, "global_position", target_pos, return_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	await active_tween.finished

	if not is_instance_valid(current_camera) or restarting:
		return

	is_panning = false
	play_letterbox_out()

func trigger_dialogue():
	if restarting:
		return

	if dialogue_manager:
		print("Triggering dialogue after letterbox.")
		dialogue_manager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		AudioPlayer.play_DIA(dia_start, -12.0)
		should_show_dialogue = false
	else:
		print("ERROR: DialogueManager not found!")

func force_reset():
	restarting = true

	if active_tween and active_tween.is_running():
		active_tween.kill()

	state = State.IDLE
	is_panning = false

	if animator.is_playing():
		animator.stop()

	visible = false

	if player:
		player.set_movement_locked(false)

	if timer_manager and not was_timer_paused:
		timer_manager.set_timer_paused(false)

	var current_camera = get_viewport().get_camera_2d()
	if current_camera and player:
		current_camera.global_position = player.global_position

	await get_tree().process_frame
	restarting = false

	if pending_pan_back:
		pending_pan_back = false
		_cutscene_camera_pan()
