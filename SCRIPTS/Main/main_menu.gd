extends Control

@onready var transition_fx = preload("res://BGM/button.mp3")
@onready var logout_confirmation_dialog = $LogoutConfirmationDialog
var option_instance = null
var is_dialog_open = false  # Flag to track if the dialog is open

func _ready() -> void:
	MenuMusic.play_menu_music()

	# Manually connect the 'confirmed' signal of the dialog to the handler function
	logout_confirmation_dialog.connect("confirmed", Callable(self, "_on_LogoutConfirmationDialog_confirmed"))

func _process(_delta: float) -> void:
	pass

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

func _on_logout_button_pressed() -> void:
	# Check if dialog is already open
	if not is_dialog_open:
		AudioPlayer.play_FX(transition_fx, -12.0)
		print("Showing logout confirmation dialog...")
		logout_confirmation_dialog.popup_centered()
		is_dialog_open = true  # Set flag to indicate dialog is open
	else:
		print("Logout confirmation dialog is already open.")

# This method is triggered when the user confirms the logout from the dialog
func _on_LogoutConfirmationDialog_confirmed() -> void:
	print("Logout confirmation confirmed")

	# Reset the user data by calling the reset function
	UserDataManager.reset_user_data()  # Should work now

	# Optionally, you can print the file contents to confirm it's wiped
	var file_check = FileAccess.open("res://SAVES/save_state.json", FileAccess.READ)
	if file_check:
		print("Wiped Save File Contents: ", file_check.get_as_text())
		file_check.close()

	# Hide the dialog after confirmation
	logout_confirmation_dialog.hide()

	# Delay scene change to allow the save to complete
	await get_tree().create_timer(0.5).timeout  # Await for timer timeout

	# Change to login scene after logout
	get_tree().change_scene_to_file("res://SCENES/Main/Login.tscn")
