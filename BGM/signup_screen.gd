extends Control

var password_hidden := true  # Track password visibility state
@onready var transition_fx = preload("res://BGM/button.mp3")

func _ready() -> void:
	Firebase.Auth.signup_succeeded.connect(_on_signup_success)
	Firebase.Auth.signup_failed.connect(_on_signup_fail) #changed here "_on_signup_fail removed"
	print("✅ Signup screen loaded.")

# ✅ Navigate back to login screen
func _on_back_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	print("🔙 Returning to login screen...")
	get_tree().change_scene_to_file("res://SCENES/Main/Login.tscn")

# ✅ Handle signup button press
func _on_signup_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	var email_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Email Container/Email Edit")
	var password_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit")

	if not email_edit or not password_edit: #changed here "not email or not password edit"
		print("❌ Error: Required input fields missing!")
		return

	var email = email_edit.text.strip_edges()
	var password = password_edit.text.strip_edges()

	if email.is_empty() or password.is_empty():
		print("⚠ Warning: Email and password cannot be empty!")
		_update_state_label("Please enter email and password.")
		return

	print("🔍 Attempting signup with email:", email)
	Firebase.Auth.signup_with_email_and_password(email, password) #changed here "Auth Removed"

# ✅ Handle successful signup
func _on_signup_success(auth_data: Dictionary) -> void:
	print("✅ Signup successful! Sending verification email...")

	var result = await Firebase.Auth.send_account_verification_email()
	if result:
		print("📩 Verification email sent successfully.")
		_update_state_label("Verification email sent! Please check your inbox.")
		await get_tree().create_timer(5.0).timeout #changed "await Removed"
		_on_back_button_pressed()  # Redirect back to login

# ❌ Handle failed signup
func _on_signup_fail(error_code: int, message: String) -> void:
	print("❌ Signup failed! Error:", message)
	_update_state_label("Signup failed: " + message)

# ✅ Show/Hide Password Functionality
func _on_show_password_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	var password_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit")

	if password_edit:
		password_hidden = !password_hidden  # Toggle state #changed here "! removed"
		password_edit.secret = password_hidden  # Update visibility
	else:
		print("❌ Error: Could not find PasswordLine")


# ✅ Update state label text (for error messages or status updates)
func _update_state_label(text: String) -> void:
	var state_label = get_node_or_null("statelabel")
	if state_label:
		state_label.text = text
