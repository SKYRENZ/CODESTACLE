extends Control

@onready var background_texture = $Background  
@onready var sentence_label = $Panel/Label
@onready var hbox_container = $Panel/VBoxContainer/HBoxContainer
@onready var validation_panel = $Panel  

# 🎨 UI Assets
@export var font_resource: Font  
@export var background_image: Texture  

var sentence_template = "Let [_] = 12; Let y = [_];"  
var valid_items = ["12", "13"]  
var collected_items = []  
var next_expected_index = 0  

func _ready():
	# ✅ Set Background Image (if provided)
	if background_image and background_texture:
		background_texture.texture = background_image  

	# ✅ Apply font styling
	if font_resource:
		sentence_label.add_theme_font_override("font", font_resource)
		sentence_label.add_theme_color_override("font_color", Color(1, 1, 1))  
		sentence_label.add_theme_font_size_override("font_size", 32)  
		sentence_label.alignment = HORIZONTAL_ALIGNMENT_CENTER  

	update_sentence_display()

func _process(_delta):
	# ✅ Toggle validation panel with "F"
	if Input.is_action_just_pressed("toggle_validation"):
		validation_panel.visible = !validation_panel.visible  

func update_sentence_display():
	# Clear existing children in HBoxContainer
	for child in hbox_container.get_children():
		hbox_container.remove_child(child)
		child.queue_free()  

	# Split sentence where blanks (_) exist
	var parts = sentence_template.split("_")

	for i in range(parts.size()):
		var text_label = Label.new()
		text_label.text = parts[i]
		text_label.add_theme_font_override("font", font_resource)  
		text_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))  
		text_label.add_theme_font_size_override("font_size", 32)  
		text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  
		hbox_container.add_child(text_label)

		# If there's a collected item, insert its texture in the blank
		if i < collected_items.size():
			var texture_rect = TextureRect.new()
			texture_rect.texture = collected_items[i]  
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Keeps aspect ratio centered
			texture_rect.custom_minimum_size = Vector2(48, 48)  # Ensures it doesn't exceed size
			texture_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			texture_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			hbox_container.add_child(texture_rect)

func add_item(item_name, item_texture) -> bool:
	# ✅ Always open validation panel when collecting an item
	if not validation_panel.visible:
		validation_panel.visible = true  

	if item_name in valid_items:
		var expected_item = valid_items[next_expected_index]

		if item_name == expected_item:
			collected_items.append(item_texture)  
			next_expected_index += 1  
			update_sentence_display()  
			change_panel_color(Color(0.5, 1.0, 0.5))  # ✅ Green for correct
			return true
		else:
			change_panel_color(Color(1.0, 0.5, 0.5))  # ❌ Red for incorrect order
			return false
	else:
		change_panel_color(Color(1.0, 0.5, 0.5))  # ❌ Red for invalid item
		return false

func change_panel_color(color: Color):
	validation_panel.modulate = color  
	await get_tree().create_timer(0.3).timeout  
	validation_panel.modulate = Color(1, 1, 1)  
