extends Area2D

@onready var InteractionLabel: Label = $".."

func _ready():
	if InteractionLabel:
		InteractionLabel.visible = false  # Start hidden
	connect_signals()

func connect_signals():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_started(_resource: DialogueResource):
	if InteractionLabel:
		InteractionLabel.visible = false

func _on_dialogue_ended(_resource: DialogueResource):
	if InteractionLabel and get_overlapping_bodies().any(func(body): return body.is_in_group("player")):
		InteractionLabel.visible = true

func _on_body_entered(body):
	if body.is_in_group("player") and InteractionLabel:
		InteractionLabel.visible = true

func _on_body_exited(body):
	if body.is_in_group("player") and InteractionLabel:
		InteractionLabel.visible = false
