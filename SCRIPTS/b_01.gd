extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ladder_ray_cast: RayCast2D = $LadderRayCast

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 200.0

var is_on_ladder = false

func _ready():
	print("Player script is running")

func _physics_process(delta: float) -> void:
	# Check for ladder collision using RayCast2D
	var ladderCollider = ladder_ray_cast.get_collider()
	is_on_ladder = ladderCollider != null

	# Handle movement and animations
	if is_on_ladder:
		_ladder_climb()
	else:
		_movement(delta)

	# Apply gravity only if not on a ladder
	if not is_on_floor() and not is_on_ladder:
		velocity += get_gravity() * delta

	move_and_slide()

	# Flip sprite based on movement direction
	animated_sprite_2d.flip_h = velocity.x < 0

func _movement(delta):
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle horizontal movement
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, 12)
		animated_sprite_2d.play("default")

func _ladder_climb():
	var climb_direction := Input.get_axis("up", "down")
	var move_direction := Input.get_axis("left", "right")

	velocity.x = move_direction * SPEED / 2  # Allow slight horizontal movement
	velocity.y = climb_direction * CLIMB_SPEED if climb_direction else 0

	animated_sprite_2d.play("climbing" if climb_direction else "default")

# Detect when the player enters or exits a ladder area
func _on_ladder_area_entered(area: Area2D):
	if area.is_in_group("ladder"):
		print("Entered ladder area")
		is_on_ladder = true

func _on_ladder_area_exited(area: Area2D):
	if area.is_in_group("ladder"):
		print("Exited ladder area")
		is_on_ladder = false
