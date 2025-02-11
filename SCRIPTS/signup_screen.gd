extends Control

func _ready() -> void:
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/Login.tscn")

func _on_signup_button_pressed() -> void:
	var email = %"Email Edit".text
	var password = %"Password Edit".text
	Firebase.Auth.signup_with_email_and_password(email, password)

func on_signup_succeeded(auth):
	print("Signup succeeded. Attempting to send verification email...")
	var result = await Firebase.Auth.send_account_verification_email()
	if result:
		print("Verification email sent successfully.")
		await get_tree().create_timer(5.0).timeout
		get_tree().change_scene_to_file("res://SCENES/Login.tscn")
	else:
		print("Failed to send verification email.")


func on_signup_failed(error_code, message):
	print("Signup failed. Error code: ", error_code)
	print("Error message: ", message)
