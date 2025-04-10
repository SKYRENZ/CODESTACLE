extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ladder_ray_cast: RayCast2D = $LadderRayCast
@onready var spawn_point: Marker2D = null

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const CLIMB_SPEED = 200.0
const MOVEMENT_THRESHOLD = 10  
const MOVEMENT_SPAM_THRESHOLD = 200
const SPAM_COOLDOWN = 0.8

var is_on_ladder = false
var movement_locked = false
var facing_direction = 1

#progress bar
var doors = []
var max_distance = 0.0
var progress_bar = null


var floor_controller = null

var last_lateral_speed = 0.0
var spam_timer = 0.0

func _ready():
	print("Player script is running")
	if not is_in_group("player"):
		add_to_group("player")

	floor_controller = get_tree().get_current_scene()

	if floor_controller:
		print("Floor controller found:", floor_controller.name)
	else:
		print("Error: Floor controller not found!")

	# Find the progress bar instance
	progress_bar = get_tree().get_nodes_in_group("progress_bar")[0] if get_tree().has_group("progress_bar") else null
	if not progress_bar:
		print("Error: Progress bar not found!")


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

	#Progress Bar function
	if doors.size() > 0 and progress_bar:
		var current_distance = global_position.distance_to(doors[0].global_position)
		var progress = 1.0 - (current_distance / max_distance)
		progress_bar.update_progress(progress)


func apply_gravity():
	print("Gravity reapplied to player!")
	velocity.y = 400

func set_movement_locked(locked: bool) -> void:
	movement_locked = locked
	if locked:
		velocity = Vector2.ZERO
		animated_sprite_2d.play("default")

func _movement(delta):
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_on_ladder:
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jumping")
		print("Jumping animation triggered")

	# Get input direction
	var direction := Input.get_axis("left", "right")
	var lateral_speed = abs(velocity.x)

	# Update spam timer
	if lateral_speed > MOVEMENT_SPAM_THRESHOLD:
		spam_timer += delta
	else:
		spam_timer = 0.0

	# Apply horizontal movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	# Handle animation logic
	if is_on_floor():
		# Reset to default animation when on the floor
		if animated_sprite_2d.animation == "jumping" or animated_sprite_2d.animation == "falling":
			animated_sprite_2d.play("default")  # Reset to the default animation once landed
		elif direction:
			animated_sprite_2d.play("walking")  # Play walking if moving
		else:
			animated_sprite_2d.play("default")  # Play default if standing still
	else:
		# Handle jump and fall animations while in the air
		if velocity.y < 0:  # Going up
			if animated_sprite_2d.animation != "jumping":
				animated_sprite_2d.play("jumping")
		elif velocity.y > 0:  # Falling down
			if animated_sprite_2d.animation != "falling":
				animated_sprite_2d.play("falling")
			# Ensure frame 0 or 1 is playing while airborne
			if animated_sprite_2d.frame >= 2:
				animated_sprite_2d.frame = 0

func _wait_for(duration: float) -> void:
	var start_time = Time.get_ticks_msec()
	while Time.get_ticks_msec() - start_time < duration * 1000:
		await get_tree().process_frame

func _handle_falling_animation():
	if is_on_floor() and animated_sprite_2d.animation == "falling":
		animated_sprite_2d.frame = 2
		_wait_for(0.2)  # Wait for a short duration
		animated_sprite_2d.play("default")  # Reset to default animation after landing

func _physics_process_async():
	while true:
		await get_tree().process_frame
		_handle_falling_animation()

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
