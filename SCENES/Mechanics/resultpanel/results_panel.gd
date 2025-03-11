extends CanvasLayer

# Define the signal that DoorController is looking for
signal results_closed

# References to UI elements
var panel
var title_label
var score_label
var time_label
var continue_button

func _ready():
	print_debug("ResultPanel: _ready called")
	
	# Create UI elements
	create_ui_elements()
	
	# Connect button signal - using direct connection
	continue_button.connect("pressed", Callable(self, "_on_continue_pressed"))
	
	print_debug("ResultPanel: Continue button connected with signal: " + str(continue_button.is_connected("pressed", Callable(self, "_on_continue_pressed"))))
	
	# Add a debug key for testing
	set_process_input(true)

func _input(event):
	# Debug key to test signal emission (press the 'C' key)
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		print_debug("ResultPanel: Debug 'C' key pressed, calling _on_continue_pressed()")
		_on_continue_pressed()

func create_ui_elements():
	# Main panel
	panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.set_size(Vector2(500, 350))
	add_child(panel)
	
	# Title
	title_label = Label.new()
	title_label.text = "Floor Complete!"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.set_position(Vector2(0, 30))
	title_label.set_size(Vector2(500, 40))
	title_label.add_theme_font_size_override("font_size", 28)
	panel.add_child(title_label)
	
	# Score result
	score_label = Label.new()
	score_label.text = "Quiz Score: 0%"
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.set_position(Vector2(0, 120))
	score_label.set_size(Vector2(500, 30))
	score_label.add_theme_font_size_override("font_size", 22)
	panel.add_child(score_label)
	
	# Time result
	time_label = Label.new()
	time_label.text = "Floor Time: 00:00.00"
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_label.set_position(Vector2(0, 170))
	time_label.set_size(Vector2(500, 30))
	time_label.add_theme_font_size_override("font_size", 22)
	panel.add_child(time_label)
	
	# Continue button
	continue_button = Button.new()
	continue_button.text = "Continue (Click or Press C)"
	continue_button.set_position(Vector2(150, 250))
	continue_button.set_size(Vector2(200, 60))
	panel.add_child(continue_button)
	
	# Add a debug label
	var debug_label = Label.new()
	debug_label.text = "If button doesn't work, press 'C' key"
	debug_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	debug_label.set_position(Vector2(0, 320))
	debug_label.set_size(Vector2(500, 20))
	debug_label.add_theme_font_size_override("font_size", 14)
	panel.add_child(debug_label)

# Show the results panel with calculated data
func show_results(floor_number: int, quiz_score: int = -1):
	print_debug("ResultPanel: show_results called for floor " + str(floor_number))
	
	# Update floor name in title
	title_label.text = "Floor " + str(floor_number) + " Complete!"
	
	# Update quiz score
	score_label.text = "Quiz Score: " + str(quiz_score) + "%"
	
	# Show the panel
	panel.visible = true
	
	# Important: We want to still process inputs for our C key debug
	get_tree().paused = false

# Handle continue button press
func _on_continue_pressed():
	print_debug("ResultPanel: Continue button pressed or C key pressed")
	print_debug("ResultPanel: About to emit results_closed signal")
	
	# Signal that the player can now proceed
	emit_signal("results_closed")
	print_debug("ResultPanel: Signal emitted")
	
	# Wait a moment before cleanup
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	
	print_debug("ResultPanel: Cleaning up")
	queue_free()
