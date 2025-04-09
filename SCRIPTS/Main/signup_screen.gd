extends Control

var firebase_api_key = OS.get_environment("FIREBASE_API_KEY")
var password_hidden := true  # Track password visibility state

# Firestore Manager and User Data Manager instances (autoloaded)
var firestore_manager : FirestoreManager  # Firestore Manager (for saving to Firestore)
var user_data_manager : UserDataManager  # User Data Manager (for saving locally)

var local_storage_path = "res://SAVES/save_state.json"  # Path to save local data

var verification_timer : Timer  # Timer to periodically check for email verification
var verification_retries = 10  # Max retries before giving up on email verification
var retries_left = verification_retries  # Number of retries remaining

var current_user_data = null  # Variable to store current user data

func _ready() -> void:
	# Connect signals
	Firebase.Auth.signup_succeeded.connect(Callable(self, "_on_signup_success"))
	Firebase.Auth.signup_failed.connect(Callable(self, "_on_signup_fail"))
	print("✅ Signup screen loaded.")

	# Initialize and start the timer for email verification check
	verification_timer = Timer.new()
	add_child(verification_timer)
	verification_timer.wait_time = 5.0  # Check every 5 seconds
	verification_timer.one_shot = false  # Repeat until email is verified
	verification_timer.connect("timeout", Callable(self, "_on_verification_timeout"))

# ✅ Signup button press handler
func _on_signup_button_pressed() -> void:
	print("🔘 Signup button pressed!")

	var email_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Email Container/Email Edit")
	var password_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit")
	var confirm_password_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit2")
	var username_edit = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Username Container/Username Edit")
	var notification_label = get_node_or_null("NotificationLabel")

	if not email_edit or not password_edit or not confirm_password_edit or not username_edit or not notification_label:
		print("❌ Error: Missing UI elements!")
		return

	var email = email_edit.text.strip_edges()
	var password = password_edit.text.strip_edges()
	var confirm_password = confirm_password_edit.text.strip_edges()
	var username = username_edit.text.strip_edges()

	print("📩 Entered Email:", email)
	print("🔑 Entered Password:", password)
	print("🔄 Confirm Password:", confirm_password)
	print("🖋 Entered Username:", username)

	var validation_errors := []

	# Validate email format
	if not _is_valid_email(email):
		validation_errors.append("⚠ Invalid email format! Must be name@domain.com")

	# Validate password strength
	if not _is_valid_password(password):
		validation_errors.append("⚠ Password must be at least 6 characters and contain a number!")

	# Confirm passwords match
	if password != confirm_password:
		validation_errors.append("⚠ Passwords do not match!")

	if validation_errors.size() > 0:
		notification_label.text = "\n".join(validation_errors)
		print("❌ Signup failed due to validation errors.")
		return

	print("✅ Valid input. Attempting signup...")

	notification_label.text = "⏳ Signing up..."
	Firebase.Auth.signup_with_email_and_password(email, password)

# Email validation function
func _is_valid_email(email: String) -> bool:
	var result = email.match("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
	return result != null

# Password validation function
func _is_valid_password(password: String) -> bool:
	var result = password.match(".*[0-9].*")
	if password.length() < 6:
		return false
	elif result == null:
		return false
	return true

# Handle successful signup
func _on_signup_success(auth) -> void:
	print("Signup response:", auth)  # Log the entire auth object to see its structure
	var email = ''
	
	# Retrieve email, user_id, and username from auth data
	if auth.has("email"):
		email = auth["email"]
	else:
		email = "Guest"
		
	if auth.has("localid"):
		var user_id = auth["localid"]
		var username = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Username Container/Username Edit").text.strip_edges()
		
		# Store user data
		current_user_data = {
			"email": email,
			"localid": user_id,
			"username": username
		}
		
		# Add the user's username to Firestore
		var user_data = {"username": username, "email": email}
		var collection = Firebase.Firestore.collection("users")
		
		var document = await collection.get_doc(user_id)
		
		if document:
			await document.update(user_data)
			print("Document updated successfully")
		else:
			var new_doc = await collection.add(user_id, user_data)
			print("Document created successfully")
		
		# Fetch and print the ID token
		if auth.has("idToken"):  # Check for 'idToken' in the auth object
			print("ID Token: ", auth["idToken"])  # Log the ID token
			var account_verification_body = {
				"requestType": "verify_email",
				"idToken": auth["idToken"]
			}
			
			var result = await Firebase.Auth.send_email_verification(account_verification_body)
			print("nagana nato")
			
			if result:
				print("Verification email sent.")
			else:
				print("Failed to send verification email.")
		
		# Notify the user about the verification email
		var popup_status = get_node_or_null("PopupStatusLabel")
		if popup_status:
			popup_status.text = "Signup Success! Please check your email to verify."
		else:
			print("Error: Popup or Status label is missing.")
		
		# Start checking email verification status
		verification_timer.start()
	else:
		print("Error: Missing user ID in response")
		var status_label = get_node_or_null("StatusLabel")
		if status_label:
			status_label.text = "Error: Missing user ID in response."
		else:
			print("Error: Status label is missing.")

# Handle failed signup
func _on_signup_fail(error_code: int, message: String) -> void:
	print("❌ Signup failed! Error:", message)
	var notification_label = get_node_or_null("NotificationLabel")
	if notification_label:
		notification_label.text = "❌ Signup failed: " + message

# Handle back button press (go back to login screen)
func _on_back_button_pressed() -> void:
	print("🔙 Returning to login screen...")
	get_tree().change_scene_to_file("res://SCENES/Main/Login.tscn")

# Function to check email verification status
func _on_verification_timeout() -> void:
	print("⏳ Checking for email verification...")

	# Use the stored user data instead of calling get_current_user()
	if current_user_data:
		# Fetch the current user to check email verification status
		var user = Firebase.Auth.get_current_user()  # This should return the current user object
		if user:
			if user.has("email_verified") and user["email_verified"]:
				print("✅ Email verified. Proceeding with saving data.")
				_on_email_verified(current_user_data)
			else:
				print("❌ Email not verified yet. Retrying...")
				retries_left -= 1
				if retries_left <= 0:
					print("❌ Max retries reached. Could not verify email.")
					verification_timer.stop()
		else:
			print("❌ No user found. Please log in again.")
	else:
		print("❌ No user data available.")

# Function to handle actions after email is verified
func _on_email_verified(user_data) -> void:
	var email = user_data.email
	var user_id = user_data.localid
	var username = user_data.username
	var password = get_node_or_null("NinePatchRect/Container/Signup Container/User and Pass Container/Password Container/Password Edit").text.strip_edges()

	# Save the user data (both locally and in Firestore)
	user_data_manager.save_user_data_locally(email, user_id, username, password)
	firestore_manager.save_user_data_to_firestore(email, user_id, username, password)

	# Update the notification label
	var notification_label = get_node_or_null("NotificationLabel")
	if notification_label:
		notification_label.text = "✅ Email verified and data saved."

	# Redirect after saving data
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.start()
	await timer.timeout  # Wait for the timer to finish before redirecting
	_on_back_button_pressed()  # Navigate back to login screen
