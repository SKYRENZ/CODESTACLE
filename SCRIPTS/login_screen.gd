extends Control

var firebase_api_key = "AIzaSyB02zOyEW28ep26AAlVWrzRD1X3Hwznp1A"
var email = ""
var password = ""

func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	print("✅ Login screen loaded.")

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
		var id_token = auth_data["idtoken"]
		print("🔑 Received ID Token:", id_token)

		# ✅ Check email verification
		check_email_verification(id_token)
	else:
		print("❌ Error: No ID token found in auth_data!", auth_data)

# ❌ Callback for failed login
func on_login_failed(error_code: int, message: String) -> void:
	print("❌ Login failed! Error:", message)
	var state_label = get_node_or_null("statelabel")
	if state_label:
		state_label.text = "Login failed: " + message
	else:
		print("⚠ Warning: statelabel node not found.")

# ✅ Check if email is verified using Firebase REST API
func check_email_verification(user_id_token: String) -> void:
	var url = "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=" + firebase_api_key
	var headers = ["Content-Type: application/json"]
	var body = {"idToken": user_id_token}

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_verification_response)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

	if error != OK:
		print("❌ HTTP Request failed to start!")

	print("🔍 Checking email verification status...")

# ✅ Handle Firebase API response for verification check
func _on_verification_response(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	print("🔄 Firebase Response:", response_text)  # Log full response for debugging

	var response = JSON.parse_string(response_text)

	if response and response.has("users") and response["users"].size() > 0:
		var user_info = response["users"][0]
		var is_verified = user_info.get("emailVerified", false)

		if is_verified:
			print("✅ Email is verified! Redirecting to main menu...")
			get_tree().change_scene_to_file("res://SCENES/main_menu.tscn")
		else:
			print("❌ Email not verified. Please verify your email.")
			var state_label = get_node_or_null("statelabel")
			if state_label:
				state_label.text = "Please verify your email before logging in."

			# ✅ Start auto-login check every few seconds
			print("🔄 Waiting for email verification...")
			await get_tree().create_timer(5.0).timeout
			refresh_id_token()  # Re-check email verification automatically
	else:
		print("❌ Error: Failed to check email verification status.")

# ✅ Refresh user token & re-check verification
func refresh_id_token() -> void:
	print("🔄 Refreshing user authentication...")
	
	var url = "https://securetoken.googleapis.com/v1/token?key=" + firebase_api_key
	var headers = ["Content-Type: application/json"]
	var body = {
		"grant_type": "refresh_token",
		"refresh_token": Firebase.Auth.refresh_token
	}

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_refresh_token_response)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

	if error != OK:
		print("❌ Failed to refresh token!")

# ✅ Handle Firebase Token Refresh
func _on_refresh_token_response(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	print("🔄 Refresh Token Response:", response_text)

	var response = JSON.parse_string(response_text)

	if response and response.has("id_token"):
		var new_id_token = response["id_token"]
		print("✅ Refreshed ID Token:", new_id_token)
		check_email_verification(new_id_token)  # 🔄 Recheck email verification with new token
	else:
		print("❌ Failed to refresh ID token!")

# ✅ Auto login once the user verifies email
func auto_login_after_verification() -> void:
	print("🔄 Reattempting login after email verification...")
	await get_tree().create_timer(2.0).timeout  # Wait a little before re-login
	Firebase.Auth.login_with_email_and_password(email, password)

# ✅ Handles signup button click
func _on_signup_button_pressed() -> void:
	print("🔄 Navigating to signup screen...")
	get_tree().change_scene_to_file("res://SCENES/signup_screen.tscn")

# ✅ Send email verification after signup
func send_verification_email() -> void:
	print("📩 Sending verification email...")
	
	var result = await Firebase.Auth.send_email_verification()

	if result == OK:
		print("✅ Verification email sent successfully!")
	else:
		print("⚠ Warning: Firebase returned an error, but the email might still be sent.")
		print("⚠ Firebase Response Code:", result)

# ✅ Handles Google SSO login
func _on_google_sso_pressed() -> void:
	print("🌐 Google SSO button pressed. Starting login...")
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.get_auth_localhost(provider)
