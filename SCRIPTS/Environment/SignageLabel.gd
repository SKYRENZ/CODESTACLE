extends Area2D

@onready var InteractionLabel: Label = $".."
var is_read = false
var player_in_range = false

func _ready():
	if InteractionLabel:
		InteractionLabel.visible = false # Start hidden
	connect_signals()

func connect_signals():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _process(_delta):
	# Check for interaction while player is in range
	if player_in_range and not is_read and Input.is_action_just_pressed("interact"):
		is_read = true
		ObjectiveManager.increment_signage_read()
		print("SignageLabel: increment_signage_read called")
		# You might want to hide the interaction label here
		if InteractionLabel:
			InteractionLabel.visible = false

func _on_dialogue_started(_resource: DialogueResource):
	if InteractionLabel:
		InteractionLabel.visible = false

func _on_dialogue_ended(_resource: DialogueResource):
	if InteractionLabel and get_overlapping_bodies().any(func(body): return body.is_in_group("player")):
		InteractionLabel.visible = true

func _on_body_entered(body):
	if body.is_in_group("player") or body.name == "Player":
		player_in_range = true
		if InteractionLabel and not is_read:
			InteractionLabel.visible = true

func _on_body_exited(body):
	if body.is_in_group("player") or body.name == "Player":
		player_in_range = false
		if InteractionLabel:
			InteractionLabel.visible = false
