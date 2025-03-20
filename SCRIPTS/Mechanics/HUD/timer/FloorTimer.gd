extends CanvasLayer

var timer_label
var floor_label
var timer_manager = null

# Called when the node enters the scene tree
func _ready():
	# Get references to the existing UI elements in the scene
	timer_label = $Panel/Timer_Panel
	floor_label = $Panel/Floor_Label
	
	# Get reference to the timer manager
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	
	if timer_manager == null:
		print("ERROR: FloorTimerManager not found!")
		return
		
	# Update floor label
	floor_label.text = "FLOOR: " + str(timer_manager.current_floor)
	
	# Initial timer display is already set in the scene

# Called every frame
func _process(delta):
	if timer_manager and timer_manager.timer_running:
		var current_time = Time.get_unix_time_from_system() - timer_manager.start_time
		timer_label.text = timer_manager.format_time(current_time)
