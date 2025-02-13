extends CharacterBody2D

var player_in_range = false
var ui  # Stores reference to UI node
var quiz_popup  # Stores reference to the quiz popup

func _ready():
	# Get the UI node from the scene
	ui = get_tree().current_scene.get_node_or_null("UI")
	quiz_popup = get_tree().current_scene.get_node_or_null("QuizPopup")
	if ui:
		print("✅ UI found:", ui)
	else:
		print("❌ ERROR: UI NOT FOUND!")
	if quiz_popup:
		print("✅ QuizPopup found:", quiz_popup)
		quiz_popup.get_node("Node2D").connect("quiz_completed", Callable(self, "_on_quiz_completed"))
	else:
		print("❌ ERROR: QuizPopup NOT FOUND!")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		show_interact_prompt(true)  # Show "Press E"

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		show_interact_prompt(false)  # Hide "Press E"
		show_dialogue_box(false)  # Hide dialogue

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

func interact():
	show_interact_prompt(false)  # Hide "Press E"
	show_dialogue_box(false)  # Hide dialogue
	if quiz_popup:
		quiz_popup.popup_centered()  # Show the quiz popup

func _on_quiz_completed():
	if quiz_popup:
		quiz_popup.hide()  # Hide the quiz popup
	show_dialogue_box(true, "Congrats, you can now continue on your journey")

# Function to show/hide "Press E" prompt
func show_interact_prompt(is_visible):
	if ui:
		var interact_prompt = ui.get_node_or_null("InteractPrompt")
		if interact_prompt:
			interact_prompt.visible = is_visible
			print("InteractPrompt visible:", is_visible)
		else:
			print("❌ ERROR: InteractPrompt NOT FOUND!")

# Function to show/hide dialogue box
func show_dialogue_box(is_visible, text=""):
	if ui:
		var dialogue_box = ui.get_node_or_null("DialogueBox")
		var dialogue_text = ui.get_node_or_null("DialogueBox/DialogueText")  # Adjust if necessary
		if dialogue_box and dialogue_text:
			dialogue_text.text = text
			dialogue_box.visible = is_visible
			print("DialogueBox visible:", is_visible, "| Text:", text)
		else:
			print("❌ ERROR: DialogueBox or DialogueText NOT FOUND!")
