extends Control


var quit_button = null

func _ready() -> void:
	quit_button = get_node_or_null("/root/quit_button")
	if quit_button == null:
		print("ERROR: FloorTimerManager not found!")
		return


func _on_yes_pressed() -> void:
	get_tree().quit()


func _on_no_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENES/Main/main_menu.tscn")
