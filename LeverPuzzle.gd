extends Node2D

@onready var wall_collider = $Wall/WallCollider
@onready var input_box = $CommandBox/Panel/InputBox
@onready var command_ui = $CommandBox
@onready var lever_area = $LeverArea
@onready var lever_sprite = $LeverSprite

var command_required := "true"
var player_in_range := false
var is_command_active := false
var has_been_solved := false
var current_player = null

func _ready():
	wall_collider.disabled = false
	command_ui.visible = false

	if input_box and not input_box.text_submitted.is_connected(_on_text_submitted):
		input_box.text_submitted.connect(_on_text_submitted)

	if lever_area:
		lever_area.body_entered.connect(_on_body_entered)
		lever_area.body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_range and not is_command_active and not has_been_solved:
		if Input.is_action_just_pressed("interact"):
			_show_command_ui()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		current_player = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		current_player = null

func _show_command_ui():
	is_command_active = true
	command_ui.visible = true
	input_box.text = ""
	input_box.grab_focus()

	if current_player:
		current_player.set_movement_locked(true)

func _on_text_submitted(command: String):
	command = command.strip_edges().to_lower()
	print("📝 Submitted command:", command)

	if command == command_required:
		print("✅ Correct command! Wall collider disabled.")
		has_been_solved = true
		wall_collider.set_deferred("disabled", true)
		if lever_sprite:
			lever_sprite.play("on")
	else:
		print("❌ Incorrect command.")

	# Close command UI
	command_ui.visible = false
	is_command_active = false

	# Resume player movement
	if current_player:
		current_player.set_movement_locked(false)
