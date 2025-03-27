extends Control

@onready var sentence_label = $Panel/Label
@onready var vbox_container = $Panel/VBoxContainer
@onready var validation_panel = $Panel  

var sentence_template = []
var valid_items = []
var collected_items = []  # Store item names instead of textures
var next_expected_index = 0  
var current_floor  

func _ready():
	await get_tree().process_frame  

	var floor_node = get_tree().get_first_node_in_group("floor")
	if floor_node:
		if floor_node.has_meta("floor_number"):
			current_floor = floor_node.get_meta("floor_number")  
		elif "floor_number" in floor_node:
			current_floor = floor_node.floor_number
		else:
			print("⚠️ Warning: Floor node does not have 'floor_number'!")
			current_floor = -1  
	else:
		print("⚠️ Warning: Floor node not found!")
		current_floor = -1  

	print("🟢 Detected Floor:", current_floor)

	var floor_data = FloorData.get_floor_data(current_floor)
	print("📜 Floor Data Retrieved:", floor_data)

	if floor_data and "valid_items" in floor_data:
		sentence_template = floor_data.sentence_template
		valid_items = floor_data.valid_items  

		print("✅ Loaded Floor Data:", floor_data)
		print("🎯 Valid Items:", valid_items)

		setup_label_style()
		update_ui()
	else:
		print("❌ Error: No valid items found in floor data for floor", current_floor)

func setup_label_style():
	# Load a small custom font
	var custom_font = load("res://ASSETS/FONT/Eight-Bit Madness.ttf")  # Replace with your actual font path
	if custom_font:
		sentence_label.add_theme_font_override("font", custom_font)

	# Adjust text alignment
	sentence_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sentence_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Enable word wrapping
	sentence_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Increase line spacing
	sentence_label.add_theme_constant_override("line_spacing", 10)

	# Add left padding
	sentence_label.add_theme_constant_override("margin_left", 200)  # Adjust as needed

	# Make sure label expands properly
	sentence_label.custom_minimum_size = Vector2(400, 200)
	sentence_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sentence_label.size_flags_vertical = Control.SIZE_EXPAND_FILL

func update_ui():
	if sentence_label:
		sentence_label.text = "\n".join(sentence_template)

		# Reapply small font to prevent size reset
		var custom_font = load("res://small_font.tres")
		if custom_font:
			sentence_label.add_theme_font_override("font", custom_font)

		print("📜 Updating Label Text:", sentence_label.text)
	else:
		print("⚠️ Warning: sentence_label not found!")

	if validation_panel:
		validation_panel.visible = true
	else:
		print("⚠️ Warning: validation_panel is missing!")

func add_item(item_name, item_texture) -> bool:
	open_validation()  

	var item_value = item_name
	if item_name.is_valid_int():
		item_value = item_name.to_int()

	var converted_valid_items = valid_items.map(func(item):
		return int(item) if typeof(item) == TYPE_STRING and item.is_valid_int() else item
	)

	print("🔎 Checking Item:", item_value, "Expected:", converted_valid_items)

	if item_value in converted_valid_items:
		var expected_item = converted_valid_items[next_expected_index]

		if item_value == expected_item:
			collected_items.append(item_name)  # Store the item's name
			next_expected_index += 1  
			update_sentence_display()  
			change_panel_color(Color(0.5, 1.0, 0.5))  
			print("✅ Item accepted:", item_value)
			return true
		else:
			change_panel_color(Color(1.0, 0.5, 0.5))  
			print("❌ Wrong order:", item_value, "Expected:", expected_item)
			return false
	else:
		change_panel_color(Color(1.0, 0.5, 0.5))  
		print("❌ Invalid item:", item_value, "Valid options:", converted_valid_items)
		return false

func open_validation():
	validation_panel.visible = true

func change_panel_color(color: Color):
	validation_panel.modulate = color  
	await get_tree().create_timer(0.3).timeout  
	validation_panel.modulate = Color(1, 1, 1)  

func update_sentence_display():
	if sentence_label:
		var display_text = ""
		var collected_index = 0

		for line in sentence_template:
			var parts = line.split("_")
			var line_text = ""

			for i in range(parts.size()):
				line_text += parts[i]
				if i < parts.size() - 1 and collected_index < collected_items.size():
					line_text += collected_items[collected_index]  # Use the collected item's name
					collected_index += 1

			display_text += line_text + "\n"

		sentence_label.text = display_text.strip_edges()

		# Reapply small font to prevent resets
		var custom_font = load("res://small_font.tres")
		if custom_font:
			sentence_label.add_theme_font_override("font", custom_font)

		print("📜 Updating Label Text:", sentence_label.text)
	else:
		print("⚠️ Warning: sentence_label not found!")
