extends Area2D

@export var item_name: String = "DefaultItem"
@export var item_texture: Texture  

var player_nearby: bool = false
var original_position: Vector2  # Store original position

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	original_position = global_position  # Store where it spawned

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_nearby = false

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("interact"):
		validate_item()

func validate_item():
	var validation = get_tree().get_first_node_in_group("Validation")  
	if validation:
		if validation.add_item(item_name, item_texture):  
			queue_free()  # ✅ Remove if accepted
		else:
			respawn_item()  # ❌ Respawn if rejected

func respawn_item():
	await get_tree().create_timer(1.0).timeout  # Add delay before respawning
	var new_item = duplicate()  # Create a copy of this collectible
	get_parent().add_child(new_item)  # Add to the scene
	new_item.global_position = original_position  # Reset position
	queue_free()  # Remove the current instance
