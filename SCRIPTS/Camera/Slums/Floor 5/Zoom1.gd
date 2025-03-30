extends Area2D

@export var camera: Camera2D

var original_offset: Vector2
var normal_zoom = Vector2(2, 2)
var zoomed_out = Vector2(1, 1)  # Adjust as needed
var original_position_smoothing: bool
var zoom_speed = 1.5  # Increased duration for smoother transition

var tween: Tween

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	if not camera:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			camera = player.get_node("Camera2D")

func _on_body_entered(body):
	if body.is_in_group("player") and camera:
		print("Player entered zoom-out area!")
		original_offset = camera.offset
		original_position_smoothing = camera.position_smoothing_enabled

		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(camera, "zoom", zoomed_out, zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_callback(_lock_camera_offset).set_delay(zoom_speed * 0.5)  # Delay locking offset

func _on_body_exited(body):
	if body.is_in_group("player") and camera:
		print("Player exited zoom-out area! Restoring camera settings.")
		camera.set_process(true)
		camera.position_smoothing_enabled = original_position_smoothing

		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(camera, "zoom", normal_zoom, zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_callback(_restore_camera_offset).set_delay(zoom_speed + 0.1)  # Delay restoring offset

func _lock_camera_offset():
	if camera:
		camera.offset = Vector2.ZERO  # Lock camera in place
		camera.position_smoothing_enabled = false  # Disable smoothing
		camera.set_process(false)

func _restore_camera_offset():
	if camera:
		camera.offset = original_offset
