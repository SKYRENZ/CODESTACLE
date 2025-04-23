extends Control

@onready var transition_fx = preload("res://BGM/button.mp3")
var floor_buttons := {}

func _ready() -> void:
	# Load progress from local save
	var user_data = UserDataManager.load_local_user_data()
	var progress = user_data.get("progress", {})

	# Find and store all floor buttons
	for i in range(1, 11):
		var button_name = "Floor %d" % i
		var button_node = get_node_or_null(button_name)
		if button_node:
			var floor_key = "floor_%d" % i
			floor_buttons[floor_key] = button_node

			# Unlock logic
			if i == 1 or progress.has("floor_%d" % (i - 1)):
				_unlock_button(floor_key)
			else:
				_lock_button(floor_key)

func _unlock_button(floor_name: String) -> void:
	if floor_buttons.has(floor_name):
		var button = floor_buttons[floor_name]
		button.disabled = false
		button.modulate = Color.WHITE

func _lock_button(floor_name: String) -> void:
	if floor_buttons.has(floor_name):
		var button = floor_buttons[floor_name]
		button.disabled = true
		button.modulate = Color.GRAY
