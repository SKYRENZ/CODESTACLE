extends Node2D

@onready var wall_collider = $Wall/WallCollider  # The collider that blocks the player
@onready var lever_area = $LeverArea  # The area where the player needs to interact
@onready var lever_sprite = $LeverSprite  # Lever sprite to show if it's "on" or "off"
@onready var blocking_sprite = $LeverArea/BlockingSprite  # AnimatedSprite2D that visually blocks the player

var command_box_scene: PackedScene = preload("res://CommandBox.tscn")
var command_box_instance = null

var command_required := "false;"
var player_in_range := false
var is_command_active := false
var has_been_solved := false
var current_player = null

func _ready():
	# Make sure the wall collider is enabled initially
	wall_collider.disabled = false

	if lever_area:
		lever_area.body_entered.connect(_on_body_entered)  # Player enters range
		lever_area.body_exited.connect(_on_body_exited)  # Player exits range

func _process(_delta):
	# Show the command UI when the player is in range and presses "interact"
	if player_in_range and not is_command_active and not has_been_solved:
		if Input.is_action_just_pressed("interact"):
			_show_command_ui()

func _on_body_entered(body):
	# Detect when the player enters the interaction range
	if body.is_in_group("player"):
		player_in_range = true
		current_player = body
		print("Player entered the lever area.")

func _on_body_exited(body):
	# Detect when the player leaves the interaction range
	if body.is_in_group("player"):
		player_in_range = false
		current_player = null
		print("Player exited the lever area.")

func _show_command_ui():
	# Show the command UI if it's not active and the puzzle hasn't been solved yet
	if is_command_active or has_been_solved:
		return

	is_command_active = true
	command_box_instance = command_box_scene.instantiate()

	get_tree().current_scene.add_child(command_box_instance)  # Adds it to the current scene
	command_box_instance.position = Vector2(200, 100)  # Position the command box on the screen

	command_box_instance.required_command = command_required
	command_box_instance.correct_command_entered.connect(_on_correct_command)  # When the command is correct
	command_box_instance.wrong_command_entered.connect(_on_wrong_command)  # When the command is wrong
	command_box_instance.open()

	if current_player:
		current_player.set_movement_locked(true)  # Prevent the player from moving while UI is active

func _on_correct_command():
	print("✅ Correct command! Wall collider disabled.")
	has_been_solved = true
	wall_collider.set_deferred("disabled", true)  # Disable the wall collider to let the player pass

	if lever_sprite:
		lever_sprite.play("on")  # Play the "on" animation for the lever sprite
	
	if blocking_sprite:
		print("Playing 'on' animation for BlockingSprite...")
		blocking_sprite.play("on")  # Play the "on" animation for the blocking sprite
		
		# Connect the animation_finished signal to remove the node after the animation
		blocking_sprite.animation_finished.connect(_on_blocking_sprite_animation_finished)

	_close_command_ui()

func _on_blocking_sprite_animation_finished():
	print("BlockingSprite animation finished. Removing node.")
	blocking_sprite.queue_free()  # Remove the blocking sprite from the scene

func _on_wrong_command():
	print("❌ Incorrect command.")
	_close_command_ui()

func _close_command_ui():
	is_command_active = false
	if current_player:
		current_player.set_movement_locked(false)  # Re-enable movement for the player
