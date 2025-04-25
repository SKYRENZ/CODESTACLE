extends Area2D

const CodePopupScene = preload("res://SCENES/FLOOR/Slums/CodePopup/CodePopup.tscn")
@export var code_file_path : String = "res://SCENES/FLOOR/Slums/CodePopup/External JavaScript.txt"

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print("Player entered area")
		
		# Load code from file
		var file = FileAccess.open(code_file_path, FileAccess.READ)
		if file != null:
			var code_text = file.get_as_text()
			file.close()
			
			# Instantiate the popup
			var popup = CodePopupScene.instantiate()
			
			# Set the code in the TextEdit
			popup.get_node("CodeDisplay").text = code_text


			
			# Add to the scene
			get_tree().current_scene.add_child(popup)
		else:
			printerr("Error: Could not open code file:", code_file_path)
