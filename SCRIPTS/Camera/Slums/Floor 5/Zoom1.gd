extends Area2D

@export var camera: Camera2D

var original_offset: Vector2
var normal_zoom = Vector2(2, 2)
var zoomed_out = Vector2(2.3, 2.3)  # Adjust as needed
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

		camera.offset = Vector2.ZERO  # Lock camera immediately
		camera.position_smoothing_enabled = false  # Disable smoothing
		camera.set_process(false)

		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(camera, "zoom", zoomed_out, zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_body_exited(body):
	if body.is_in_group("player") and camera:
		print("Player exited zoom-out area! Restoring camera settings.")

		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(camera, "zoom", normal_zoom, zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_callback(_restore_camera_offset).set_delay(zoom_speed * 0.5)  # Delay unlocking for smoothness

func _restore_camera_offset():
	if camera:
		camera.offset = original_offset
		camera.position_smoothing_enabled = original_position_smoothing  # Restore smoothing
		camera.set_process(true)
