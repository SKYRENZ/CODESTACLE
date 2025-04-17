extends CanvasLayer

@onready var top_bar = $ColorRectTop
@onready var bottom_bar = $ColorRectBot
@onready var animator = $AnimationPlayer
@onready var signage_label = $Label  # Assuming you have a Label for cutscene text (can be skipped if you don't want text)

enum {
	IDLE,
	SHOWING,
	HIDING
}

var state: int = IDLE
var should_show_dialogue = false  # Flag to trigger dialogue after hide animation
var dialogue_resource: DialogueResource = null  # Placeholder for dialogue resource
var dialogue_start: String = ""  # Placeholder for dialogue start key
var dia_start: AudioStream = null  # Placeholder for dialogue audio stream

func _ready():
	visible = false
	print("LetterBox is ready!")

	# Connect to the 'animation_finished' signal to handle the end of animations
	animator.connect("animation_finished", Callable(self, "_on_animation_finished"))

# Play animation to show the letterbox (like a cutscene intro)
func play_letterbox_in():
	if state == IDLE:
		state = SHOWING
		print("Playing 'show' animation...")
		visible = true  # Make it visible right away to prepare for the animation
		animator.stop()  # Ensure any previous animation is stopped
		animator.play("show")  # Play the 'show' animation
	else:
		print("LetterBox is already showing.")

# Play animation to hide the letterbox (like a cutscene outro)
func play_letterbox_out():
	if state == IDLE:
		state = HIDING
		print("Playing 'hide' animation...")
		animator.stop()  # Stop any previous animation
		animator.play("hide")  # Play the 'hide' animation
	else:
		print("LetterBox is already hiding.")

# This method will be called when the animation finishes
func _on_animation_finished(anim_name: String) -> void:
	print("Animation finished:", anim_name)
	if anim_name == "show" and state == SHOWING:
		state = IDLE
		print("LetterBox is now visible.")
		# Once show animation finishes, trigger the hide animation
		play_letterbox_out()  # Start the hide animation
	elif anim_name == "hide" and state == HIDING:
		state = IDLE
		print("LetterBox is now hidden.")
		visible = false  # Hide the letterbox again

		# Now that the "hide" animation finished, trigger the dialogue
		if should_show_dialogue and dialogue_resource:
			trigger_dialogue()

# This function triggers the dialogue after the letterbox animation finishes
func trigger_dialogue():
	print("Triggering dialogue after letterbox hide.")
	# Assuming you are calling DialogueManager to show the dialogue
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	AudioPlayer.play_DIA(dia_start, -12.0)

	# Reset the flag to prevent the dialogue from showing again
	should_show_dialogue = false
