extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ladder_ray_cast: RayCast2D = $LadderRayCast
@onready var spawn_point: Marker2D = null
@onready var camera = $Camera2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 200.0
const OFFSET_DELAY = 0.0
const MOVEMENT_THRESHOLD = 10  
const CENTER_DELAY = 0.42
const CAMERA_FOLLOW_SPEED = 0.8
const MOVEMENT_SPAM_THRESHOLD = 200
const SPAM_COOLDOWN = 0.8
const PANNING_DELAY = 0.8

var is_on_ladder = false
var movement_locked = false
var facing_direction = 1

# NEW variables to store door info & HUD
var doors = []
var max_distance = 0.0
var floor_controller = null

# Camera movement variables
var camera_offset = Vector2(180, 0)
var target_offset = Vector2.ZERO
var direction_change_timer = 0.5
var last_direction = 0
var camera_stop = 0.0
var camera_delay_timer = 0.5

var last_lateral_speed = 0.0
var spam_timer = 0.0
var panning_locked = false
var panning_delay_timer = 0.5

func _ready():
	print("Player script is running")
	if not is_in_group("player"):
		add_to_group("player")

	floor_controller = get_tree().get_current_scene()

	if floor_controller:
		print("Floor controller found:", floor_controller.name)
	else:
		print("Error: Floor controller not found!")

	camera.position_smoothing_enabled = false
	camera.position_smoothing_speed = 0.0

func _physics_process(delta: float) -> void:
	if movement_locked:
		if not is_on_floor() and not is_on_ladder:
			velocity += get_gravity() * delta
			move_and_slide()
		return

	var ladderCollider = ladder_ray_cast.get_collider()
	is_on_ladder = ladderCollider != null

	if is_on_ladder:
		_ladder_climb()
	else:
		_movement(delta)

	if not is_on_floor() and not is_on_ladder:
		velocity += get_gravity() * delta

	move_and_slide()

	if velocity.x != 0:
		facing_direction = sign(velocity.x)
	animated_sprite_2d.flip_h = facing_direction < 0

	_update_progress()

func apply_gravity():
	print("Gravity reapplied to player!")
	velocity.y = 400

func set_movement_locked(locked: bool) -> void:
	movement_locked = locked
	if locked:
		velocity = Vector2.ZERO
		animated_sprite_2d.play("default")

func _movement(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_on_ladder:
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jumping")
		print("Jumping animation triggered")

	var direction := Input.get_axis("left", "right")
	var lateral_speed = abs(velocity.x)

	if lateral_speed > MOVEMENT_SPAM_THRESHOLD:
		spam_timer += delta
		if spam_timer > SPAM_COOLDOWN:
			panning_locked = false
	else:
		spam_timer = 0.0
		panning_locked = false

	if not panning_locked:
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
		print("Entered ladder area")
		is_on_ladder = true

func _on_ladder_area_exited(area: Area2D):
	if area.is_in_group("ladder"):
		print("Exited ladder area")
		is_on_ladder = false

func _on_void_area_entered(body):
	if body.is_in_group("player"):
		_on_player_died()

func _on_player_died():
	velocity = Vector2.ZERO
	is_on_ladder = false
	if spawn_point:
		global_position = spawn_point.global_position
		print("Player Respawned at:", spawn_point.global_position)
	else:
		print("Error: SpawnPoint not set!")

func _on_checkpoint_reached(checkpoint: Area2D):
	if checkpoint.has_node("Spawnpoint"):
		spawn_point = checkpoint.get_node("Spawnpoint")
		print("Checkpoint reached! New spawn point set at:", spawn_point.global_position)
	else:
		print("Error: Checkpoint missing 'Point'!")

func _process(delta: float):
	var direction = sign(velocity.x)

	if abs(velocity.x) < MOVEMENT_THRESHOLD:
		direction_change_timer = 0
	else:
		if direction != 0 and direction != last_direction:
			direction_change_timer = 0  
		else:
			direction_change_timer += delta  

	last_direction = direction  

	if direction != last_direction and direction != 0 and not panning_locked:
		camera_stop = 0  
		target_offset = Vector2.ZERO  

	if velocity.x == 0:
		camera_stop += delta
		if camera_stop >= CENTER_DELAY:
			target_offset = Vector2.ZERO  
	else:
		camera_stop = 0  

	if direction_change_timer >= OFFSET_DELAY:
		if direction > 0 and not panning_locked:
			target_offset = camera_offset
		elif direction < 0 and not panning_locked:
			target_offset = -camera_offset

	if panning_delay_timer > 0:
		panning_delay_timer -= delta  
		return  

	if not panning_locked:
		camera.offset = lerp(camera.offset, target_offset, CAMERA_FOLLOW_SPEED * delta)

	if direction != last_direction and direction != 0:
		panning_delay_timer = PANNING_DELAY  

func _update_progress():
	if doors.is_empty() or floor_controller == null:
		print("Error: Doors list is empty or floor controller is null!")
		return

	var closest_distance = INF
	for door in doors:
		if door:
			var dist = global_position.distance_to(door.global_position)
			if dist < closest_distance:
				closest_distance = dist

	var progress = 1.0 - (closest_distance / max_distance)
	progress = clamp(progress, 0, 1)
	print("Progress calculated:", progress)
	floor_controller.update_progress_bar(progress)
