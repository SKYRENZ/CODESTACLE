extends CanvasLayer

@onready var anim_player = $AnimationPlayer

func _ready():
	print("_ready")
	fade_in()  # Ensure the game starts with a fade-in effect

func fade_in():
	print("🎬 Playing fade-in animation...")

	if anim_player:
		print("⏳ Found AnimationPlayer, playing fade_in animation...")
		anim_player.play("fade_in")
		await anim_player.animation_finished
		print("✔ Fade-in animation finished!")
	else:
		print("⚠ ERROR: AnimationPlayer not found in Transition!")

func fade_out():
	print("🎬 Playing fade-out animation...")

	if anim_player:
		print("⏳ Found AnimationPlayer, playing fade_out animation...")
		anim_player.play("fade_out")
		await anim_player.animation_finished
		print("✔ Fade-out animation finished!")
	else:
		print("⚠ ERROR: AnimationPlayer not found in Transition!")
