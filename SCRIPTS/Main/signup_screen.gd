extends Control

var password_hidden := true

func _ready() -> void:
	Firebase.Auth.signup_succeeded.connect(_on_signup_success)
	Firebase.Auth.signup_failed.connect(_on_signup_fail)
	print("✅ Signup screen loaded.")

func _on_back_button_pressed() -> void:
	print("🔙 Returning to login screen...")
	get_tree().change_scene_to_file("res://SCENES/Main/Login.tscn")

func _on_signup_button_pressed() -> void:
	print("🔘 Signup button pressed!")

	var email_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Email Container/Email Edit")
	var password_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit")
	var confirm_password_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit2")
	var notification_label = get_node_or_null("NotificationLabel")

	if not email_edit or not password_edit or not confirm_password_edit or not notification_label:
		print("❌ Error: Missing UI elements!")
		return

	var email = email_edit.text.strip_edges()
	var password = password_edit.text.strip_edges()
	var confirm_password = confirm_password_edit.text.strip_edges()

	print("📩 Entered Email:", email)
	print("🔑 Entered Password:", password)
	print("🔄 Confirm Password:", confirm_password)

	var validation_errors := []

	if not _is_valid_email(email):
		validation_errors.append("⚠ Invalid email format! Must be name@domain.com")

	if not _is_valid_password(password):
		validation_errors.append("⚠ Password must be at least 6 characters and include a number.")

	if password != confirm_password:
		validation_errors.append("⚠ Passwords do not match!")

	if validation_errors.size() > 0:
		notification_label.text = "\n".join(validation_errors)
		print("❌ Signup failed due to validation errors.")
		return

	print("✅ Valid input. Attempting signup...")
	notification_label.text = "⏳ Signing up..."
	Firebase.Auth.signup_with_email_and_password(email, password)

func _is_valid_email(email: String) -> bool:
	var regex := RegEx.new()
	regex.compile("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")
	return regex.search(email) != null

func _is_valid_password(password: String) -> bool:
	var has_min_length = password.length() >= 6
	var has_number = RegEx.new()
	has_number.compile("\\d")
	return has_min_length and has_number.search(password) != null

func _on_signup_success(auth_data: Dictionary) -> void:
	print("✅ Signup successful! Sending verification email...")
	var notification_label = get_node_or_null("NotificationLabel")
	if notification_label:
		notification_label.text = "✅ Signup successful! Sending verification email..."

	var result = await Firebase.Auth.send_account_verification_email()
	if result:
		print("📩 Verification email sent successfully.")
		if notification_label:
			notification_label.text = "📩 Verification email sent! Redirecting to login..."
		await get_tree().create_timer(5.0).timeout
		_on_back_button_pressed()

func _on_signup_fail(error_code: int, message: String) -> void:
	print("❌ Signup failed! Error:", message)
	var notification_label = get_node_or_null("NotificationLabel")
	if notification_label:
		notification_label.text = "❌ Signup failed: " + message

func _on_show_password_button_pressed() -> void:
	var password_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit")
	var confirm_password_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit2")

	if password_edit and confirm_password_edit:
		password_hidden = !password_hidden
		password_edit.secret = password_hidden
		confirm_password_edit.secret = password_hidden
		print("👁 Password visibility toggled:", not password_hidden)
	else:
		print("❌ Error: Could not find Password Edit fields!")
