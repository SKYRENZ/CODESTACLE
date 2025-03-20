extends CanvasLayer
var signage_count: int = 0

func _ready():
	print("hello world") # testing purpose
	ObjectiveManager.connect("objective_updated", Callable(self, "_on_objective_updated"))
	print("Connected signal: objective_updated")

	# Find the FloorController to access the signage count.
	var floor_controller = find_parent("FloorController")
	if floor_controller:
		signage_count = floor_controller.signage_count
		print("ObjectivesHUD: signage_count from FloorController is", signage_count)
	else:
		printerr("FloorController not found! Ensure ObjectivesHUD is a child (or grandchild) of the FloorController.")
		return
	
	# Update the HUD initially
	update_hud_text()

# This function receives the signal
func _on_objective_updated(current, total):
	print("Signal received in Objectives! Current:", current, " Total:", total)
	update_hud_text()

func update_objective(index: int, text: String):
	var labels = $Panel/Objective_label/VboxContainer.get_children()
	if index < labels.size():
		labels[index].text = text

func set_signage_count(count):
	signage_count = count
	update_hud_text()

func update_hud_text():
	var label_node = $Panel/Objectives_label/VBoxContainer/Objectives
	if label_node != null:
		label_node.text = "%d/%d Signage Read" % [ObjectiveManager.current_read, signage_count]
		print("HUD updated to show: ", label_node.text)
	else:
		printerr("Error: Label node not found in ObjectivesHUD!")
		# Debug node structure
		print_debug_node_structure()
		
func print_debug_node_structure():
	print("Available nodes in Panel path:")
	var panel = $Panel
	if panel:
		print("Panel exists. Children: ", panel.get_children())
		var objectives_label = panel.get_node_or_null("Objectives_label")
		if objectives_label:
			print("Objectives_label exists. Children: ", objectives_label.get_children())
		else:
			print("Objectives_label not found under Panel")
	else:
		print("Panel node not found")
