extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ladder_ray_cast: RayCast2D = $LadderRayCast
@onready var spawn_point: Marker2D = null

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 200.0

var is_on_ladder = false
var movement_locked = false
var facing_direction = 1

# Variables for doors & progress tracking
var doors = []
var max_distance = 0.0
var floor_controller = null

func _ready():
	print("[Player] Script is running")
	if not is_in_group("player"):
		add_to_group("player")

	floor_controller = get_tree().get_current_scene()

	if floor_controller:
		print("[Player] Floor controller found:", floor_controller.name)
	else:
		print("[Player] ERROR: Floor controller not found!")

func _physics_process(delta: float) -> void:
	if movement_locked:
		# Prevent all movement but apply gravity if needed
		if not is_on_floor() and not is_on_ladder:
			velocity += get_gravity() * delta
			move_and_slide()
		return  # ✅ Fully stop input when locked

	var ladderCollider = ladder_ray_cast.get_collider()
	is_on_ladder = ladderCollider != null

	if is_on_ladder:
		_ladder_climb()
	else:
		_movement(delta)

	if not is_on_floor() and not is_on_ladder:
		velocity += get_gravity() * delta

	move_and_slide()

	# Flip sprite based on movement direction
	if velocity.x != 0:
		facing_direction = sign(velocity.x)
	animated_sprite_2d.flip_h = facing_direction < 0

	# Update Progress Bar every frame
	_update_progress()

func apply_gravity():
	print("[Player] Gravity applied!")
	velocity.y = 400

func set_movement_locked(locked: bool) -> void:
	movement_locked = locked
	if locked:
		velocity = Vector2.ZERO  # ✅ Fully freeze player
		animated_sprite_2d.play("default")  
		print("[Player] Movement locked")
	else:
		print("[Player] Movement unlocked")

func _movement(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_on_ladder:
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jumping")
		print("[Player] Jumping")

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, 20)
		animated_sprite_2d.play("default")

func _ladder_climb():
	var climb_direction := Input.get_axis("up", "down")
	var move_direction := Input.get_axis("left", "right")

	velocity.x = move_direction * SPEED / 2
	velocity.y = climb_direction * CLIMB_SPEED if climb_direction else 0

	animated_sprite_2d.play("climbing" if climb_direction else "default")

func _on_ladder_area_entered(area: Area2D):
	if area.is_in_group("ladder"):
		print("[Player] Entered ladder area")
		is_on_ladder = true

func _on_ladder_area_exited(area: Area2D):
	if area.is_in_group("ladder"):
		print("[Player] Exited ladder area")
		is_on_ladder = false

func _on_void_area_entered(body):
	if body.is_in_group("player"):
		_on_player_died()

func _on_player_died():
	velocity = Vector2.ZERO
	is_on_ladder = false
	if spawn_point:
		global_position = spawn_point.global_position
		print("[Player] Respawned at:", spawn_point.global_position)
	else:
		print("[Player] ERROR: SpawnPoint not set!")

func _on_checkpoint_reached(checkpoint: Area2D):
	if checkpoint.has_node("Spawnpoint"):
		spawn_point = checkpoint.get_node("Spawnpoint")
		print("[Player] Checkpoint reached! New spawn point set at:", spawn_point.global_position)
	else:
		print("[Player] ERROR: Checkpoint missing 'Point'!")

# ✅ Ensures progress updates
func _update_progress():
	if doors.is_empty() or floor_controller == null:
		print("[Player] ERROR: Doors list empty or floor controller missing!")
		return

	var closest_distance = INF
	for door in doors:
		if door:
			var dist = global_position.distance_to(door.global_position)
			if dist < closest_distance:
				closest_distance = dist

	var progress = 1.0 - (closest_distance / max_distance)
	progress = clamp(progress, 0, 1)
	print("[Player] Progress:", progress)
	floor_controller.update_progress_bar(progress)
