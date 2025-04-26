extends Control

@onready var transition_fx = preload("res://BGM/button.mp3")
@onready var logout_confirmation_dialog = $LogoutConfirmationDialog
var option_instance = null
var is_dialog_open = false  # Flag to track if the dialog is open

func _ready() -> void:
	MenuMusic.play_menu_music()

	# Connect signals only if not already connected
	if not logout_confirmation_dialog.is_connected("confirmed", Callable(self, "_on_LogoutConfirmationDialog_confirmed")):
		logout_confirmation_dialog.connect("confirmed", Callable(self, "_on_LogoutConfirmationDialog_confirmed"))

	if not logout_confirmation_dialog.is_connected("canceled", Callable(self, "_on_logout_confirmation_dialog_canceled")):
		logout_confirmation_dialog.connect("canceled", Callable(self, "_on_logout_confirmation_dialog_canceled"))

func _process(_delta: float) -> void:
	pass

func _on_Leaderboards_pressed() ->void:
	get_tree().change_scene_to_file("res://SCENES/Main/Leaderboard.tscn")

func _on_play_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().change_scene_to_file("res://SCENES/Main/stage_select.tscn")

func _on_quit_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	get_tree().change_scene_to_file("res://SCENES/Main/quit_confirmation.tscn")

func _on_option_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	if option_instance == null:
		var option_scene = ResourceLoader.load("res://SCENES/Mechanics/Option/volume_sliders.tscn")
		if option_scene:
			option_instance = option_scene.instantiate()
			option_instance.name = "OptionInstance"
			get_tree().root.add_child(option_instance)
			print("Option scene displayed!")
			print("Current Scene Tree: ", get_tree().root.get_children())
		else:
			print("Error: Failed to load option.tscn!")
	else:
		print("Option scene is already displayed!")

# Trigger the logout confirmation dialog
func _on_logout_button_pressed() -> void:
	if not is_dialog_open:
		AudioPlayer.play_FX(transition_fx, -12.0)
		print("Showing logout confirmation dialog...")
		logout_confirmation_dialog.popup_centered()
		is_dialog_open = true
	else:
		print("Logout confirmation dialog is already open.")

# Called when the user confirms logout
func _on_LogoutConfirmationDialog_confirmed() -> void:
	print("Logout confirmation confirmed")

	# Start logout process (skip backup creation during logout)
	BackupSave.start_logout_process()

	# Reset all user data
	reset_all_user_data()

	# Optional file check for debug
	var file_check = FileAccess.open("res://SAVES/save_state.json", FileAccess.READ)
	if file_check:
		var file_content = file_check.get_as_text()
		print("Wiped Save File Contents: ", file_content)
		file_check.close()
	else:
		print("Could not open save file for verification.")

	# Hide the dialog and reset flag
	logout_confirmation_dialog.hide()
	is_dialog_open = false

	# Delay scene change to allow the save to complete
	await get_tree().create_timer(0.5).timeout

	# Log out from Firebase
	Firebase.Auth.logout()

	# End logout process (enable backup saving again)
	BackupSave.end_logout_process()

	# Change to login scene after logout
	get_tree().change_scene_to_file("res://SCENES/Main/Login.tscn")

# Called when the user cancels the logout
func _on_logout_confirmation_dialog_canceled() -> void:
	is_dialog_open = false
	print("Logout canceled.")
	logout_confirmation_dialog.hide()

# Function to reset all user data
func reset_all_user_data() -> void:
	var save_file_path = "res://SAVES/save_state.json"

	var empty_data = {
		"email": "",
		"id_token": "",
		"progress": {},
		"uid": "",
		"username": ""
	}

	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(empty_data, "\t"))
		file.close()
		print("✅ User data has been reset and saved to: " + save_file_path)
	else:
		print("❌ Failed to open save file for resetting user data.")
