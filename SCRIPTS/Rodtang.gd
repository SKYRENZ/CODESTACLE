extends CharacterBody2D

var player_in_range = false
@onready var dialogue_box: PanelContainer = %DialogueBox
@onready var interact_prompt: Label = %InteractPrompt
@onready var dialogue_text: Label = %DialogueText

func _ready():
	print("InteractPrompt: ", interact_prompt)
	print("DialogueBox: ", dialogue_box)
	print("DialogueText: ", dialogue_text)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		if interact_prompt:
			interact_prompt.visible = true  # Show "Press E"
		else:
			print("ERROR: InteractPrompt not found!")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		if interact_prompt:
			interact_prompt.visible = false  # Hide "Press E"
		if dialogue_box:
			dialogue_box.visible = false  # Hide dialogue on exit

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

func interact():
	if interact_prompt:
		interact_prompt.visible = false  # Hide "Press E"
		print("InteractPrompt hidden")
	
	if dialogue_box and dialogue_text:
		dialogue_text.text = "Hello, Player! Welcome to Codestackle!"  # Set dialogue text
		dialogue_box.visible = true  # Show dialogue box
		print("DialogueBox shown with text:", dialogue_text.text)

	
	dialogue_box.rect_position = Vector2(100, 100)
