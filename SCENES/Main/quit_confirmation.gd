extends Control


var quit_button = null

func _ready() -> void:
	quit_button = get_node_or_null("/root/quit_button")
	if quit_button == null:
		print("ERROR: FloorTimerManager not found!")
		return
