extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Goes back to the login scene
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/Login.tscn")

func _on_signup_button_pressed() -> void:
	var email = %"Email Edit".text
	var password = %"Password Edit".text
	Firebase.Auth.signup_with_email_and_password(email, password)

# Marked as async to allow for await usage
func on_signup_succeeded(auth):
	print(auth)
	# Function for email verification
	var result = await Firebase.Auth.send_account_verification_email()
	if result:
		%statelabel.text = "Signup successful! Please check your email to verify your account."
		# Optionally, you can automatically redirect to the login screen after a delay
		await get_tree().create_timer(5.0).timeout
		get_tree().change_scene_to_file("res://SCENES/Login.tscn")
	else:
		%statelabel.text = "Email verification failed. Please try again."

func on_signup_failed(error_code, message):
	print(error_code)
	print(message)
	%statelabel.text = "Signup failed: " + message
