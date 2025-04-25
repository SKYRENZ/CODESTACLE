extends Control

@onready var transition_fx = preload("res://BGM/button.mp3")
@onready var audio_player = AudioStreamPlayer.new()  # Create an AudioStreamPlayer node
var floor_buttons := {}

func _ready() -> void:
	# Add the audio player to the scene
	add_child(audio_player)
	
	# Load progress from local save via UserDataManager
	var user_data = UserDataManager.load_user_data_with_backup_priority()
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

# Unlock a floor button
func _unlock_button(floor_name: String) -> void:
	if floor_buttons.has(floor_name):
		var button = floor_buttons[floor_name]
		button.disabled = false
		button.modulate = Color.WHITE

		# Play transition effect when button is unlocked
		audio_player.stream = transition_fx  # Assign the audio stream to the player
		audio_player.play()  # Play the sound

# Lock a floor button
func _lock_button(floor_name: String) -> void:
	if floor_buttons.has(floor_name):
		var button = floor_buttons[floor_name]
		button.disabled = true
		button.modulate = Color.GRAY
