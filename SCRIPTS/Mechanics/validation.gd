extends Control

var valid_items = ["gold_coin", "magic_key", "gemstone"]  # Correct order
var collected_items = []  # Track collected items in order
var next_expected_index = 0  # Keep track of the next expected item
var is_open = false  # Track if validation UI is open

@onready var inventory_panel = $Panel  

func _process(_delta):
	if Input.is_action_just_pressed("toggle_validation"):
		toggle_validation()

# ✅ Open/Close Validation UI
func toggle_validation():
	is_open = !is_open
	visible = is_open  # Show/Hide the validation scene
	print("📂 Validation UI:", "Opened" if is_open else "Closed")

# ✅ Add item to validation in order
func add_item(item_name, item_texture) -> bool:
	if item_name in valid_items:
		var expected_item = valid_items[next_expected_index]
		if item_name == expected_item:
			collected_items.append(item_name)
			next_expected_index += 1  # Move to next item in order
			display_item(item_texture)
			print("✅ Correct! Added:", item_name)
			return true  # ✅ Accepted
		else:
			show_wrong_feedback()  
			print("❌ Incorrect order! Expected:", expected_item, "but got:", item_name)
			return false  # ❌ Wrong order → Respawn item
	else:
		show_wrong_feedback()  
		print("❌ Item rejected:", item_name)
		return false  # ❌ Invalid item → Respawn item

# 🎨 Display collected item in UI
func display_item(item_texture):
	if not item_texture:
		print("❌ Error: No texture provided!")
		return

	var item_icon = TextureRect.new()
	item_icon.texture = item_texture
	item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	var container = $Panel/VBoxContainer
	if container:
		container.add_child(item_icon)
	else:
		print("❌ Error: VBoxContainer not found!")

# ❌ Show "wrong" effect (red flash)
func show_wrong_feedback():
	inventory_panel.modulate = Color(1, 0, 0)  
	await get_tree().create_timer(0.3).timeout
	inventory_panel.modulate = Color(1, 1, 1)

# 🔄 Reset validation (optional: call this to restart the order check)
func reset_validation():
	collected_items.clear()
	next_expected_index = 0
	print("🔄 Validation reset! Start over.")
