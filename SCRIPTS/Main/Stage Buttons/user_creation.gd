extends Control

var email: String
var uid: String
var id_token: String
var progress: Dictionary

@onready var username_edit = $"Container/Username text container/Username input/Username Container/Username edit"

func _on_confirm_button_pressed() -> void:
	var username = username_edit.text.strip_edges()
	if username == "":
		print("⚠ Username can't be empty")
		return

	print("✅ Username entered:", username)

	# Save locally
	UserDataManager.save_user_data_locally(email, uid, username, id_token, progress)

	# Save to Firestore
	FirestoreManager.save_user_data_to_firestore(email, uid, username, id_token, progress)

	# Save backup
	BackupSave.create_backup_save(email, uid, username, id_token, progress)

	# Go to main menu
	get_tree().change_scene_to_file("res://SCENES/Main/main_menu.tscn")
