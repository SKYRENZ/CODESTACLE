extends Node2D

@export var target_scene: String = "res://SCENES/FLOOR/Slums/floor 2.tscn"  
@onready var sprite = $SlumssDoor2
@onready var area = $Area2D

var player_in_area = false  

func _ready():
	print("SlumssDoor2 found?:", sprite != null)  # Debug
	if sprite:
		print("SlumssDoor2 is set up correctly.")

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("Press E to enter")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		print("E Pressed! Playing animation now.")
		await get_tree().process_frame  # Force update
		await get_tree().create_timer(2.0).timeout  # Wait before changing scene

		if ResourceLoader.exists(target_scene):
			get_tree().change_scene_to_file(target_scene)  
		else:
			print("Error: Scene path is incorrect:", target_scene)
