extends Node2D

@export var target_scene: String = "res://SCENES/FLOOR/Slums/floor 1.tscn"  
@onready var sprite = $Sprite2D
@onready var area = $Area2D

var player_in_area = false  

func _ready():
	print("Sprite2D found?:", sprite != null)  # Debug
	if sprite:
		# If using AnimatedSprite2D, replace with relevant animation handling
		print("Sprite2D is set up correctly.")

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("Checkpoint activated. Changing scene...")
		call_deferred("_change_scene")  # Use deferred call to avoid physics callback issue

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false

func _change_scene():
	MenuMusic.play_slum_music()	
	if ResourceLoader.exists(target_scene):
		get_tree().change_scene_to_file(target_scene)  # Change scene after physics step
	else:
		print("Error: Scene path is incorrect:", target_scene)
