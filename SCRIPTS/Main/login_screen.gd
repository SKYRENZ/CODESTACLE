extends Control

var firebase_api_key = OS.get_environment("FIREBASE_API_KEY")  # Load API Key from .env
var email = ""
var password = ""
var password_hidden = true  # Track password visibility state
@onready var transition_fx = preload("res://BGM/button.mp3")

func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	print("✅ Login screen loaded.")

# ✅ Handles login button press
func _on_login_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)

	var email_edit = get_node_or_null("Container/Login Container/User and Pass Container/Username Container/EmailEdit")
	var password_line = get_node_or_null("Container/Login Container/User and Pass Container/Password Container/PasswordLine")
	var notification_label = get_node_or_null("NotificationLabel")  # ✅ Use NotificationLabel

	if not email_edit or not password_line or not notification_label:
		print("❌ Error: Required input fields missing!")
		if notification_label:
			notification_label.text = "❌ Error: Missing UI elements!"
		return

	email = email_edit.text.strip_edges()
	password = password_line.text.strip_edges()

	print("📩 Entered Email:", email)
	print("🔑 Entered Password:", password)

	var validation_errors := []  # ✅ Store validation messages

	# ✅ Validate email format
	if not _is_valid_email(email):
		validation_errors.append("⚠ Invalid email format! Must be name@domain.com")

	# ✅ Validate password strength
	if not _is_valid_password(password):
		validation_errors.append("⚠ Password must be at least 6 characters and contain a number!")

	# 🚫 Stop login if validation failed
	if validation_errors.size() > 0:
		notification_label.text = "\n".join(validation_errors)  # ✅ Display errors in label
		print("❌ Login failed due to validation errors.")
		return

	print("🔍 Attempting login with email:", email)
	notification_label.text = "⏳ Logging in..."  # ✅ Show progress
	Firebase.Auth.login_with_email_and_password(email, password)

# ✅ Email validation function
func _is_valid_email(email: String) -> bool:
	return email.match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")

# ✅ Password validation function
func _is_valid_password(password: String) -> bool:
	return password.length() >= 6 and password.match(".*[0-9].*")

# ✅ Callback for successful login
func on_login_succeeded(auth_data: Dictionary) -> void:
	print("✅ Login successful!")

	var notification_label = get_node_or_null("NotificationLabel")
	if notification_label:
		notification_label.text = "✅ Login successful! Redirecting..."
	
	get_tree().change_scene_to_file("res://SCENES/Main/main_menu.tscn")

# ❌ Callback for failed login
func on_login_failed(error_code: int, message: String) -> void:
	print("❌ Login failed! Error:", message)
	var notification_label = get_node_or_null("NotificationLabel")
	if notification_label:
		notification_label.text = "❌ Login failed: " + message

# ✅ Handles signup button click
func _on_signup_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	print("🔄 Navigating to signup screen...")
	get_tree().change_scene_to_file("res://SCENES/Main/signup_screen.tscn")

# ✅ Handles Google SSO login
func _on_google_sso_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	print("🌐 Google SSO button pressed. Starting login...")
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.get_auth_localhost(provider)

# ✅ Forgot Password Functionality
func _on_forgot_btn_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	var email_edit = get_node_or_null("Container/Login Container/User and Pass Container/Username Container/EmailEdit")
	var notification_label = get_node_or_null("NotificationLabel")

	if not email_edit:
		print("❌ Error: Email input field not found!")
		return

	var email = email_edit.text.strip_edges()
	
	if email.is_empty():
		print("⚠ Warning: Email field is empty!")
		if notification_label:
			notification_label.text = "⚠ Please enter your email to reset your password."
		return

	print("📩 Sending password reset email to:", email)

	Firebase.Auth.send_password_reset_email(email)
	notification_label.text = "✅ Password reset email sent! Check your inbox."
