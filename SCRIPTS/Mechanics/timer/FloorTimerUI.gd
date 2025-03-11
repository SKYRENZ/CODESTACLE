extends CanvasLayer

var timer_label
var floor_label
var timer_manager = null

# Called when the node enters the scene tree
func _ready():
	# Create UI elements
	var timer_panel = Panel.new()
	timer_panel.name = "TimerPanel"
	timer_panel.set_position(Vector2(20, 20))
	timer_panel.set_size(Vector2(200, 80))
	add_child(timer_panel)
	
	timer_label = Label.new()
	timer_label.name = "TimerLabel"
	timer_label.set_position(Vector2(10, 10))
	timer_label.set_size(Vector2(180, 30))
	timer_panel.add_child(timer_label)
	
	floor_label = Label.new()
	floor_label.name = "FloorLabel"
	floor_label.set_position(Vector2(10, 40))
	floor_label.set_size(Vector2(180, 30))
	timer_panel.add_child(floor_label)
	
	# Get reference to the timer manager
	timer_manager = get_node_or_null("/root/FloorTimerManager")
	
	if timer_manager == null:
		print("ERROR: FloorTimerManager not found!")
		return
		
	# Update floor label
	floor_label.text = "Floor: " + str(timer_manager.current_floor)
	
	# Initial timer display
	timer_label.text = "00:00.00"

# Called every frame
func _process(delta):
	if timer_manager and timer_manager.timer_running:
		var current_time = Time.get_unix_time_from_system() - timer_manager.start_time
		timer_label.text = timer_manager.format_time(current_time)
