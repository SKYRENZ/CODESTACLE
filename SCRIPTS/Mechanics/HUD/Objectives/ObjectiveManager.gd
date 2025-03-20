extends Node
signal objective_updated(current, total)

var total_signage = 0
var current_read = 0

func set_total_signage(count):
	total_signage = count
	current_read = 0
	emit_signal("objective_updated", current_read, total_signage)
	print("ObjectiveManager: Signal emitted", current_read, total_signage)

func increment_signage_read():
	if current_read < total_signage:
		current_read += 1
		print("ObjectiveManager: Incrementing signage read to", current_read, "/", total_signage)
		emit_signal("objective_updated", current_read, total_signage)
