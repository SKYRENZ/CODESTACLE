extends CanvasLayer

@onready var title_label: Label = $TitleLabel
@onready var black_overlay: ColorRect = $BlackOverlay
@onready var transition_timer: Timer = $TransitionTimer

func _ready():
	print("✅ transition.gd is running! Checking nodes...")

	if not title_label or not black_overlay or not transition_timer:
		print("❌ ERROR: One or more nodes are missing in CanvasLayer!")
		return

	title_label.hide()
	black_overlay.visible = false

	# Ensure the timer is connected
	if not transition_timer.timeout.is_connected(_on_transition_timer_timeout):
		transition_timer.timeout.connect(_on_transition_timer_timeout)

	# Start transition
	show_title("ᜆ᜔ᜑᜒ ᜐ᜔ᜎᜓᜋ᜔ᜐ᜔", 2.0)

func show_title(title_text: String, duration: float = 5.0):
	print("⏳ Timer started for", duration, "seconds. Movement disabled.")

	title_label.text = title_text
	title_label.modulate.a = 1.0  # Ensure full opacity before fading
	title_label.show()
	black_overlay.visible = true

	# Disable player input instead of pausing the game
	var player = get_tree().get_first_node_in_group("player")
	if player:
		print("🚫 Locking player movement...")
		player.set_movement_locked(true)
	else:
		print("⚠️ No player found in group 'player'")

	transition_timer.start(duration)
	print("⏳ Timer active:", transition_timer.time_left)

	# Schedule fade-out animation
	await get_tree().create_timer(duration - 1.0).timeout  # Start fade out 1 second before timer ends
	start_fade_out()

func start_fade_out():
	print("🎭 Starting fade-out animation for title...")

	# ✅ Use create_tween() to ensure it runs even when input is disabled
	var tween = create_tween()
	tween.tween_property(title_label, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	await tween.finished  # ✅ Wait until the fade-out animation is complete
	title_label.hide()

	# ✅ Manually call `_on_transition_timer_timeout()` to continue
	_on_transition_timer_timeout()


func _on_transition_timer_timeout():
	print("🔴 Timer finished! Unlocking player movement...")

	# Hide transition UI
	title_label.hide()
	black_overlay.visible = false

	# Unlock player movement
	var player = get_tree().get_first_node_in_group("player")
	if player:
		print("✅ Unlocking movement for player:", player.name)
		player.set_movement_locked(false)
	else:
		print("⚠️ No player found in group 'player'")

	# ✅ Start loading screen and switch scene
	change_scene_with_loading("res://SCENES/FLOOR/Slums/floor_7.tscn")

func change_scene_with_loading(target_scene: String):
	print("🛠️ Preparing loading screen...")

	# ✅ Load and add the loading screen FIRST
	var loading_screen = preload("res://SCENES/Environment/LoadingScreen.tscn").instantiate()
	get_tree().root.add_child(loading_screen)

	await get_tree().process_frame  # ✅ Ensure it's rendered

	# ✅ Check if already in the scene AFTER showing the loading screen
	if get_tree().current_scene.scene_file_path == target_scene:
		print("⚠️ Already in target scene! Avoiding loop.")
		loading_screen.queue_free()  # ✅ Remove loading screen if already in scene
		return  

	# ✅ Wait for visibility
	await get_tree().create_timer(1.5).timeout  

	# ✅ Now switch to the next scene
	print("🔄 Switching to scene:", target_scene)
	get_tree().change_scene_to_file(target_scene)
