extends Node2D

@export var target_scene: String = "res://SCENES/FLOOR/Slums/floor_1.tscn"

@onready var sprite = $Sprite2D
@onready var area = $Area2D

var player_in_area = false  

func _ready():
	print("[Checkpoint] Script loaded")  
	print("[Checkpoint] Expected target_scene path:", target_scene)  
	print("[Checkpoint] Sprite2D found?:", sprite != null)  

	if sprite:
		print("[Checkpoint] Sprite2D is set up correctly.")

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("[Checkpoint] Checkpoint activated. Changing scene...")  
		call_deferred("_change_scene")  

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false

func _change_scene():
	print("[Checkpoint] Changing scene now...")  
	MenuMusic.play_slum_music()

	if target_scene == "res://SCENES/FLOOR/Slums/floor_1.tscn":
		print("[Checkpoint] Using SceneIntro for transition to Floor 1")
		var scene_intro = preload("res://SceneIntro.tscn").instantiate()
		get_tree().current_scene.add_child(scene_intro)
		scene_intro.intro_finished.connect(_change_scene_to_floor1)
	else:
		print("[Checkpoint] Directly changing scene to:", target_scene)
		get_tree().change_scene_to_file(target_scene)

func _change_scene_to_floor1():
	print("[Checkpoint] SceneIntro finished, changing to Floor 1")
	get_tree().change_scene_to_file(target_scene)
