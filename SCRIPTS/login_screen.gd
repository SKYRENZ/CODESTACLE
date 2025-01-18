extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# goes to signup scene
func _on_signup_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/signup_screen.tscn")

func _on_login_button_pressed() -> void:
	var email = %EmailEdit.text
	var password = %PasswordLine.text
	#perform login
	Firebase.Auth.login_with_email_and_password(email, password)


func on_login_succeeded(auth):
	print("login succesful: ", auth)
	get_tree().change_scene_to_file("res://SCENES/main_menu.tscn")
	

func on_login_failed(error_code, message):
	print(error_code)
	print(message)
	%statelabel.text = "login failed."


func _on_google_sso_pressed() -> void:
	var provider: AuthProvider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.get_auth_localhost(provider)
