extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)

# Goes to signup scene
func _on_signup_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/signup_screen.tscn")

# Handles login when the login button is pressed
func _on_login_button_pressed() -> void:
	var email = ""
	var password = ""

	# Check if EmailEdit node exists and get the text value
	var email_edit = $"/Container/Login Container/User and Pass Container/Username Container/EmailEdit"
	if email_edit:
		email = email_edit.text
	else:
		print("EmailEdit node not found")

	# Check if PasswordLine node exists and get the text value
	var password_line = $"/Container/Login Container/User and Pass Container/Password Container/PasswordLine"
	if password_line:
		password = password_line.text
	else:
		print("PasswordLine node not found")

	# Perform login
	Firebase.Auth.login_with_email_and_password(email, password)

# Callback for successful login
func on_login_succeeded(auth: Dictionary) -> void:
	print("Login successful: ", auth)
	var user = auth["user"]  # Get the user from the auth dictionary
	# Check if the email is verified
	if user.is_email_verified():
		print("Email verified, redirecting to main menu.")
		get_tree().change_scene("res://SCENES/main_menu.tscn")
	else:
		print("Email not verified. Please verify your email.")
		if has_node("statelabel"):
			$statelabel.text = "Please verify your email before logging in."

# Callback for failed login
func on_login_failed(error_code, message) -> void:
	print("Error code: ", error_code)
	print("Message: ", message)
	# Ensure the statelabel node exists before trying to set its text
	if has_node("statelabel"):
		$statelabel.text = "Login failed: " + message

# Handles Google SSO login
func _on_google_sso_pressed() -> void:
	print("Google SSO button pressed. Starting SSO login...")
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.get_auth_localhost(provider)

# Callback for successful SSO login
func on_sso_login_succeeded(auth: Dictionary) -> void:
	print("Google SSO login successful: ", auth)
	print("Redirecting to main menu...")
	get_tree().change_scene_to_file("res://SCENES/main_menu.tscn")
