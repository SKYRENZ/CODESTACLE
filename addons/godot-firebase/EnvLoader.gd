extends Node
class_name EnvLoader

# Directly set the Firebase API key here
var firebase_api_key := "AIzaSyB02zOyEW28ep26AAlVWrzRD1X3Hwznp1A"  # Replace with your actual API key

# Get the Firebase API key directly from the EnvLoader
func get_firebase_api_key() -> String:
	return firebase_api_key
