extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_point: Marker2D = null

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 200.0

var is_on_ladder = false

func _ready():
	print("Player script is running")
	# Spawn point will be set by the level script (Underground.gd)

func _physics_process(delta: float) -> void:
	# Animations
	if velocity.x > 1 || velocity.x < -1:
		animated_sprite_2d.play("walking")
	else:
		animated_sprite_2d.play("default")

	# Handle ladder climbing
	if is_on_ladder:
		var climb_direction := Input.get_axis("up", "down")
		if climb_direction:
			velocity.y = climb_direction * CLIMB_SPEED
		else:
			velocity.y = 0
	else:
		# Add gravity if not on a ladder
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Handle jump if not on a ladder
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_on_ladder:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle horizontal movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	move_and_slide()

	var isleft = velocity.x < 0
	animated_sprite_2d.flip_h = isleft

# Detect when the player enters or exits the ladder area
func _on_ladder_area_entered(area: Area2D):
	if area.is_in_group("ladder"):
		print("Entered ladder area")
		is_on_ladder = true

func _on_ladder_area_exited(area: Area2D):
	if area.is_in_group("ladder"):
		print("Exited ladder area")
		is_on_ladder = false

func _on_void_area_entered(body):
	if body.is_in_group("player"): # Check if the body is in the player group
		_on_player_died()

func _on_player_died():
	velocity = Vector2.ZERO
	is_on_ladder = false
	# ... any other state resets (animations, health, etc.) ...

	if spawn_point: # Check if spawn_point has been set
		global_position = spawn_point.global_position
		print("Player Respawned!")
	else:
		print("Error: SpawnPoint not set! Check Underground script.")
