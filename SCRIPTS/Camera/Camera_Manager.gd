extends Node

var current_camera: Camera2D = null
@export var default_camera: Camera2D # Assigned at runtime by player

func set_active_camera(camera: Camera2D):
	if is_instance_valid(current_camera):
		current_camera.enabled = false
	current_camera = camera
	if is_instance_valid(camera):
		camera.make_current()
		camera.enabled = true

func switch_to_player_camera():
	set_active_camera(default_camera)

func switch_to_cutscene_camera(cutscene_camera: Camera2D):
	set_active_camera(cutscene_camera)

# NEW: Play a cutscene with a temporary camera
func play_cutscene(cutscene_camera: Camera2D, duration: float, player: Node):
	if not is_instance_valid(cutscene_camera) or not is_instance_valid(player):
		printerr("Cutscene camera or player is invalid!")
		return

	# Disable player movement
	player.set_movement_locked(true)
	switch_to_cutscene_camera(cutscene_camera)

	await get_tree().create_timer(duration).timeout

	# Return to player control and camera
	switch_to_player_camera()
	player.set_movement_locked(false)
