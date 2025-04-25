extends Control

signal correct_command_entered
signal wrong_command_entered

@onready var input_box = $CanvasLayer/Panel/InputBox  # Corrected path
@onready var label = $CanvasLayer/Panel/Label        # Corrected path

var required_command: String = "false;"

func _ready():
	# Check if nodes exist before using them
	if input_box == null:
		print("Error: InputBox node not found!")
	else:
		print("InputBox node found!")

	if label == null:
		print("Error: Label node not found!")
	else:
		print("Label node found!")

	input_box.text = "True;"
	input_box.grab_focus()

	if not input_box.text_submitted.is_connected(_on_text_submitted):
		input_box.text_submitted.connect(_on_text_submitted)

func open():
	input_box.text = "True;"
	input_box.grab_focus()

func _on_text_submitted(command: String):
	command = command.strip_edges().to_lower()
	print("📝 Command submitted:", command)

	if command == required_command:
		emit_signal("correct_command_entered")
	else:
		emit_signal("wrong_command_entered")

	queue_free()
