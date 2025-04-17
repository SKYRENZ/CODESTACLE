extends Control

var firebase_api_key = OS.get_environment("FIREBASE_API_KEY")
var email = ""
var password = ""
var password_hidden = true  
@onready var transition_fx = preload("res://BGM/button.mp3")

func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)

	# 🟡 Auto-login if valid local save exists
	var saved_data = UserDataManager.load_local_user_data()
	if saved_data.has("email") and saved_data.has("id_token") and saved_data.has("uid") \
		and saved_data.email != "" and saved_data.id_token != "" and saved_data.uid != "":
		
		print("🔐 Auto-login using saved user data:", saved_data)

		FirestoreManager.save_user_data_to_firestore(
			saved_data.email,
			saved_data.uid,
			saved_data.username,
			saved_data.id_token,
			{}  # Empty progress for now
		)

		call_deferred("go_to_main_menu")
	else:
		print("✅ Login screen loaded.")

func go_to_main_menu():
	get_tree().change_scene_to_file("res://SCENES/Main/main_menu.tscn")

func _on_login_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)

	var email_edit = get_node_or_null("Container/Login Container/User and Pass Container/Username Container/EmailEdit")
	var password_line = get_node_or_null("Container/Login Container/User and Pass Container/Password Container/PasswordLine")
	var notification_label = get_node_or_null("NotificationLabel")

	if not email_edit or not password_line or not notification_label:
		print("❌ Error: Required input fields missing!")
		if notification_label:
			notification_label.text = "❌ Error: Missing UI elements!"
		return

	email = email_edit.text.strip_edges()
	password = password_line.text.strip_edges()

	var validation_errors := []

	if not _is_valid_email(email):
		validation_errors.append("⚠ Invalid email format! Must be name@domain.com")
	if not _is_valid_password(password):
		validation_errors.append("⚠ Password must be at least 6 characters and contain a number!")

	if validation_errors.size() > 0:
		notification_label.text = "\n".join(validation_errors)
		print("❌ Login failed due to validation errors:", validation_errors)
		return

	print("🔍 Attempting login with email:", email)
	notification_label.text = "⏳ Logging in..."
	Firebase.Auth.login_with_email_and_password(email, password)

func _is_valid_email(email: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")
	return regex.search(email) != null

func _is_valid_password(password: String) -> bool:
	if password.length() < 6:
		return false  
	var has_number = false
	for i in password.length():
		if password[i].is_valid_int():  
			has_number = true
			break
	return has_number  

func on_login_succeeded(auth_data: Dictionary) -> void:
	print("✅ Login successful! Auth data:", auth_data)

	# Extract necessary values
	var user_id = auth_data.get("localid", "")  # Correctly retrieve the UID
	var user_email = auth_data.get("email", "")
	var user_name = user_email.split("@")[0]  # Derive username from email
	var id_token = auth_data.get("idtoken", "")  # Correctly retrieve the ID token

	# Log the extracted data for verification
	print("🔑 User ID:", user_id)
	print("🛡️ ID Token:", id_token)

	# Check if ID token is still missing
	if id_token == "":
		print("❌ ID token is missing. Please authenticate the user first.")
		return

	# ✅ Save to Firestore
	FirestoreManager.save_user_data_to_firestore(user_email, user_id, user_name, id_token, {})

	# ✅ Save locally
	UserDataManager.save_user_data_locally(user_email, user_id, user_name, id_token, {})

	# ✅ Notify user
	var notification_label = get_node_or_null("NotificationLabel")
	if notification_label:
		notification_label.text = "✅ Login successful! Redirecting..."

	call_deferred("go_to_main_menu")

func on_login_failed(error_code: int, message: String) -> void:
	print("❌ Login failed! Error:", message)
	var notification_label = get_node_or_null("NotificationLabel")
	if notification_label:
		notification_label.text = "❌ Login failed: " + message

func _on_signup_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	print("🔄 Navigating to signup screen...")
	get_tree().change_scene_to_file("res://SCENES/Main/signup_screen.tscn")

func _on_google_sso_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	print("🌐 Google SSO button pressed. Starting login...")
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.get_auth_localhost(provider)

func _on_forgot_btn_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	var email_edit = get_node_or_null("Container/Login Container/User and Pass Container/Username Container/EmailEdit")
	var notification_label = get_node_or_null("NotificationLabel")

	if not email_edit:
		print("❌ Error: Email input field not found!")
		return

	var email = email_edit.text.strip_edges()
	
	if email.is_empty():
		if notification_label:
			notification_label.text = "⚠ Please enter your email to reset your password."
		return

	print("📩 Sending password reset email to:", email)

	var url = "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=" + firebase_api_key
	var headers = ["Content-Type: application/json"]
	var body = {"requestType": "PASSWORD_RESET", "email": email}

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_password_reset_response)
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

func _on_password_reset_response(response: Dictionary) -> void:
	var notification_label = get_node_or_null("NotificationLabel")
	if response.has("error"):
		notification_label.text = "❌ Error: " + response["error"]["message"]
	else:
		notification_label.text = "✅ Password reset email sent!"
