extends CanvasLayer

@onready var anim_player = $AnimationPlayer

# List of scenes where the transition should NOT be used
var excluded_scenes = [
	"res://SCENES/Main/login_screen.tscn",
	"res://SCENES/Main/signup_screen.tscn",
	"res://SCENES/Main/MAIN.tscn",
	"res://SCENES/Main/quit_confirmation.tscn",
	"res://SCENES/Main/Login.tscn",
	"res://SCENES/Main/stage_select.tscn",
	"res://SCENES/FLOOR/Tutorial/Tutorial.tscn",
	"res://SCENES/Main/main_menu.tscn",
	"res://SCENES/Mechanics/Option/Option.tscn",
	"res://SCENES/Mechanics/Option/GearHUD.tscn"
]

func _ready():
	print("_ready")

	# Get the current scene path
	var current_scene_path = get_tree().current_scene.scene_file_path
	print("📂 Current Scene Path:", current_scene_path)

	# If the scene is excluded, disable transitions completely
	if current_scene_path in excluded_scenes:
		print("❌ Transition Autoload disabled for", current_scene_path)
		queue_free()  # Completely remove transition node from scene tree
		return

	# Otherwise, run fade-in effect as usual
	fade_in()

func fade_in():
	if not anim_player:
		print("⚠ ERROR: AnimationPlayer not found in Transition!")
		return

	print("🎬 Playing fade-in animation...")
	anim_player.play("fade_in")
	await anim_player.animation_finished
	print("✔ Fade-in animation finished!")

func fade_out():
	if not anim_player:
		print("⚠ ERROR: AnimationPlayer not found in Transition!")
		return

	print("🎬 Playing fade-out animation...")
	anim_player.play("fade_out")
	await anim_player.animation_finished
	print("✔ Fade-out animation finished!")
