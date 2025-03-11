extends Node

# Dictionary to store completion times for each floor
var floor_times = {}

# Current floor and timer variables
var current_floor = 0
var timer_running = false
var start_time = 0

# Signal for when a floor is completed
signal floor_completed(floor_number, time_seconds)

# Start the timer for a specific floor
func start_timer(floor_number: int) -> void:
	current_floor = floor_number
	start_time = Time.get_unix_time_from_system()
	timer_running = true
	print("Timer started for floor ", floor_number)

# Stop the timer and record the time
func stop_timer() -> float:
	if not timer_running:
		return 0.0
		
	timer_running = false
	var end_time = Time.get_unix_time_from_system()
	var elapsed_time = end_time - start_time
	
	# Store the time for this floor
	if floor_times.has(current_floor):
		# Only update if new time is better
		if elapsed_time < floor_times[current_floor]:
			floor_times[current_floor] = elapsed_time
	else:
		# First completion of this floor
		floor_times[current_floor] = elapsed_time
	
	print("Floor ", current_floor, " completed in ", format_time(elapsed_time))
	
	# Emit signal with floor number and time
	emit_signal("floor_completed", current_floor, elapsed_time)
	
	return elapsed_time

# Get the best time for a specific floor
func get_best_time(floor_number: int) -> float:
	if floor_times.has(floor_number):
		return floor_times[floor_number]
	return 0.0

# Format time in minutes and seconds
func format_time(time_seconds: float) -> String:
	var minutes = int(time_seconds) / 60
	var seconds = int(time_seconds) % 60
	var milliseconds = int((time_seconds - int(time_seconds)) * 100)
	
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

# Save times to a file
func save_times() -> void:
	var save_file = FileAccess.open("user://floor_times.save", FileAccess.WRITE)
	save_file.store_var(floor_times)
	save_file.close()
	print("Floor times saved")

# Load times from a file
func load_times() -> void:
	if FileAccess.file_exists("user://floor_times.save"):
		var save_file = FileAccess.open("user://floor_times.save", FileAccess.READ)
		floor_times = save_file.get_var()
		save_file.close()
		print("Floor times loaded")
