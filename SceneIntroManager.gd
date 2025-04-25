extends Node

@export var scene_intro_scene = preload("res://SCENES/Transitions/SceneIntro.tscn")  # Path to your SceneIntro scene
@export var included_scenes = [  # List of scenes where SceneIntro should be played
	"res://SCENES/FLOOR/Slums/floor 1.tscn",
	"res://SCENES/FLOOR/Slums/floor 2.tscn"
]

signal intro_finished  # Signal emitted when the intro is finished

func _ready():
	print("[SceneIntroManager] Ready")
	var current_scene_path = get_tree().current_scene.scene_file_path
	print("📂 Current Scene Path:", current_scene_path)

	if current_scene_path in included_scenes:
		print("✅ SceneIntro required for this scene.")
		play_scene_intro()
	else:
		print("❌ SceneIntro not required for this scene.")
		emit_signal("intro_finished")  # Skip intro and emit signal immediately

func play_scene_intro():
	print("[SceneIntroManager] Playing SceneIntro...")
	var scene_intro_instance = scene_intro_scene.instantiate()
	get_tree().root.add_child(scene_intro_instance)  # Add to the root of the scene tree

	# Connect the intro_finished signal to handle when the intro is done
	scene_intro_instance.intro_finished.connect(_on_intro_finished)

func _on_intro_finished():
	print("[SceneIntroManager] SceneIntro finished.")
	emit_signal("intro_finished")  # Emit the signal to notify other systems
	queue_free()  # Remove the SceneIntroManager after its job is done
