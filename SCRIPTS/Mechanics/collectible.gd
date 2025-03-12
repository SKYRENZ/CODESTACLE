extends Area2D

@export var item_name: String = "DefaultItem"
@export var item_texture: Texture  

var player_nearby: bool = false
var original_position: Vector2  

@onready var sprite = $Sprite2D  

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	original_position = global_position  

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
	if not validation:
		print("❌ Error: Validation UI not found!")
		return  

	# Get texture from either the exported value or the sprite
	var stored_texture = item_texture if item_texture else sprite.texture
	if not stored_texture:
		print("❌ Error: No valid texture found for", item_name)
		return  

	# Open validation panel
	if validation.has_method("open_validation"):
		validation.open_validation()

	# Try to add the item
	var added = false
	if validation.has_method("add_item"):
		added = validation.add_item(item_name, stored_texture)  
	
	if added:
		print("✅ Item added to validation:", item_name)
		queue_free()  # Remove item from the scene
	else:
		print("❌ Item rejected:", item_name)
		respawn_item()  # Respawn the item if incorrect

func respawn_item():
	await get_tree().create_timer(1.0).timeout  # Add delay
	global_position = original_position  # Reset position
