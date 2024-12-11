extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#goes back to the login scene
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/Login.tscn")


func _on_signup_button_pressed() -> void:
	var email = %"Email Edit".text
	var password = %"Password Edit".text
	Firebase.Auth.signup_with_email_and_password(email, password)

func on_signup_succeeded(auth):
	print(auth)

func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
