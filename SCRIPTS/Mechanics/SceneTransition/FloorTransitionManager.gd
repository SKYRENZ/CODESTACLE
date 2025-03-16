extends CanvasLayer

signal transition_started
signal transition_halfway
signal transition_finished

@export var fade_duration: float = 1.0
@export var label_display_time: float = 0.5

var overlay: ColorRect
var floor_label: Label
var _next_scene_path: String = ""
var _is_transitioning: bool = false

func _ready():
	# Add to group so other nodes can find us
	add_to_group("transition_layer")
	
	# Get references to nodes
	overlay = $ColorRect
	floor_label = $ColorRect/FloorLabel
	
	# Initial state - make sure nodes exist first
	if overlay:
		overlay.color.a = 0
		overlay.visible = false
	
	if floor_label:
		floor_label.visible = false
		
	# Check if we're coming from a scene transition
	if name == "TransitionLayer" and overlay and overlay.visible:
		# Small delay to ensure scene is fully ready
		await get_tree().create_timer(0.1).timeout
		fade_out()

# Call this from anywhere to start a transition to a new scene
func transition_to_scene(target_scene_path: String, floor_num: int = -1):
	if _is_transitioning:
		return
		
	_is_transitioning = true
	print("Starting transition to: " + target_scene_path)
	
	# Make sure we have node references
	if !overlay or !floor_label:
		overlay = $ColorRect
		floor_label = $ColorRect/FloorLabel
		
		if !overlay or !floor_label:
			printerr("Missing overlay or floor_label nodes!")
			_is_transitioning = false
			return
	
	# Store the target scene path
	_next_scene_path = target_scene_path
	
	# Update floor label if a floor number was provided
	if floor_num > 0:
		floor_label.text = "Floor " + str(floor_num)
	
	# Make overlay visible for the transition
	overlay.visible = true
	overlay.color.a = 0
	floor_label.visible = false
	
	# Start fade-in transition
	emit_signal("transition_started")
	fade_in()

# Fade the screen to black
func fade_in():
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 1.0, fade_duration / 2.0)
	await tween.finished
	
	# Show the floor label
	floor_label.visible = true
	
	# Wait a moment to show the floor label
	await get_tree().create_timer(label_display_time).timeout
	
	emit_signal("transition_halfway")
	
	# Change the scene - use a safer approach
	if _next_scene_path != "" and ResourceLoader.exists(_next_scene_path):
		# Store the data in an autoload or global singleton if needed
		var autoload = Engine.get_singleton("SceneTransitionData")
		if autoload:
			autoload.set_transition_active(true)
			autoload.set_next_floor_number(int(floor_label.text.split(" ")[1]))
		
		# Change scene safely
		var error = get_tree().change_scene_to_file(_next_scene_path)
		if error != OK:
			printerr("Failed to change scene: ", error)
			_is_transitioning = false
			fade_out() # Fallback
	else:
		printerr("Invalid scene path: ", _next_scene_path)
		# Fade out anyway
		_is_transitioning = false
		fade_out()

# Fade from black back to the scene
func fade_out():
	# Make sure we have our node references
	if !overlay or !floor_label:
		overlay = $ColorRect
		floor_label = $ColorRect/FloorLabel
		
		if !overlay or !floor_label:
			printerr("Missing overlay or floor_label nodes during fade out!")
			_is_transitioning = false
			return
	
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.0, fade_duration / 2.0)
	await tween.finished
	
	# Hide the overlay and label
	overlay.visible = false
	floor_label.visible = false
	
	_is_transitioning = false
	emit_signal("transition_finished")
