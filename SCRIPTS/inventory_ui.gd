extends Control

@onready var container = get_node_or_null("HBoxContainer")

func _ready():
	if container == null:
		print("Error: HBoxContainer not found!")

func add_item(texture: Texture):
	if container:
		var item_icon = TextureRect.new()
		item_icon.texture = texture
		item_icon.custom_minimum_size = Vector2(32, 32)
		container.add_child(item_icon)
	else:
		print("Error: Cannot add item, container is null!")
