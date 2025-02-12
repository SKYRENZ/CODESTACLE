extends Control

var firebase_api_key = "AIzaSyB02zOyEW28ep26AAlVWrzRD1X3Hwznp1A"
var email = ""
var password = ""

func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	print("✅ Login screen loaded.")

# ✅ Handles login button press
func _on_login_button_pressed() -> void:
	var email_edit = get_node_or_null("Container/Login Container/User and Pass Container/Username Container/EmailEdit")
	var password_line = get_node_or_null("Container/Login Container/User and Pass Container/Password Container/PasswordLine")

	if not email_edit or not password_line:
		print("❌ Error: Required input fields missing!")
		return

	email = email_edit.text
	password = password_line.text
	
	print("🔍 Attempting login with email:", email)
	Firebase.Auth.login_with_email_and_password(email, password)

# ✅ Callback for successful login
func on_login_succeeded(auth_data: Dictionary) -> void:
	print("✅ Login successful! Checking email verification status...")

	if auth_data.has("idtoken"):
		check_email_verification(auth_data["idtoken"])
	else:
		print("❌ Error: No ID token found in auth_data!")

# ❌ Callback for failed login
func on_login_failed(error_code: int, message: String) -> void:
	print("❌ Login failed! Error:", message)
	var state_label = get_node_or_null("statelabel")
	if state_label:
		state_label.text = "Login failed: " + message

# ✅ Check if email is verified using Firebase REST API
func check_email_verification(user_id_token: String) -> void:
	var url = "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=" + firebase_api_key
	var headers = ["Content-Type: application/json"]
	var body = {"idToken": user_id_token}

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_verification_response)
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

	print("🔍 Checking email verification status...")

# ✅ Handle Firebase API response for verification check
func _on_verification_response(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())

	if response and response.has("users") and response["users"].size() > 0:
		var is_verified = response["users"][0].get("emailVerified", false)

		if is_verified:
			print("✅ Email is verified! Redirecting to main menu...")
			get_tree().change_scene_to_file("res://SCENES/main_menu.tscn")
		else:
			print("❌ Email not verified. Please verify your email.")
			var state_label = get_node_or_null("statelabel")
			if state_label:
				state_label.text = "Please verify your email before logging in."
			await get_tree().create_timer(5.0).timeout
			refresh_id_token()
	else:
		print("❌ Error: Failed to check email verification status.")

# ✅ Refresh user token & re-check verification
func refresh_id_token() -> void:
	print("🔄 Refreshing user authentication...")
	
	var url = "https://securetoken.googleapis.com/v1/token?key=" + firebase_api_key
	var headers = ["Content-Type: application/json"]
	var body = {"grant_type": "refresh_token", "refresh_token": Firebase.Auth.refresh_token}

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_refresh_token_response)
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

# ✅ Handle Firebase Token Refresh
func _on_refresh_token_response(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())

	if response and response.has("id_token"):
		print("✅ Refreshed ID Token:", response["id_token"])
		check_email_verification(response["id_token"])
	else:
		print("❌ Failed to refresh ID token!")

# ✅ Handles signup button click
func _on_signup_button_pressed() -> void:
	print("🔄 Navigating to signup screen...")
	get_tree().change_scene_to_file("res://SCENES/signup_screen.tscn")

# ✅ Handles Google SSO login
func _on_google_sso_pressed() -> void:
	print("🌐 Google SSO button pressed. Starting login...")
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.get_auth_localhost(provider)

# ✅ Forgot Password Functionality
func _on_forgot_btn_pressed() -> void:
	var email_edit = get_node_or_null("Container/Login Container/User and Pass Container/Username Container/EmailEdit")
	
	if not email_edit:
		print("❌ Error: Email input field not found!")
		return

	var email = email_edit.text.strip_edges()
	
	if email.is_empty():
		print("⚠ Warning: Email field is empty!")
		var state_label = get_node_or_null("statelabel")
		if state_label:
			state_label.text = "Please enter your email to reset your password."
		return

	print("📩 Sending password reset email to:", email)

	# ✅ Firebase Password Reset API
	var url = "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=" + firebase_api_key
	var headers = ["Content-Type: application/json"]
	var body = {"requestType": "PASSWORD_RESET", "email": email}

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_password_reset_response)
	http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

# ✅ Handle Firebase Password Reset Response
func _on_password_reset_response(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	var state_label = get_node_or_null("statelabel")

	if response and response.has("email"):
		print("✅ Password reset email sent successfully!")
		if state_label:
			state_label.text = "Password reset email sent! Check your inbox."
	else:
		print("❌ Failed to send password reset email.")
		if state_label:
			state_label.text = "Error: Unable to send reset email."
