extends Area2D

var player_nearby: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_nearby = false

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("Interact"):
		pickup()

func pickup():
	print("Item collected!")  # Replace this with inventory logic if needed
	queue_free()  # Remove item
