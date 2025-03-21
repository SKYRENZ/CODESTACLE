extends CanvasLayer

var signage_count: int = 0
var npc_count: int = 0

@onready var signage_label = $Panel/Objectives_label/VBoxContainer/SignageObjectives
@onready var npc_label = $Panel/Objectives_label/VBoxContainer/NPCObjectives

func _ready():
	print("hello world") # Testing purpose
	ObjectiveManager.connect("objective_updated", Callable(self, "_on_objective_updated"))
	print("Connected signal: objective_updated")

	# Find the FloorController to access the signage count and NPC count.
	var floor_controller = find_parent("FloorController")
	if floor_controller:
		signage_count = floor_controller.signage_count
		npc_count = floor_controller.npc_count  # Add this line if `npc_count` is exported in FloorController
		print("ObjectivesHUD: signage_count from FloorController is", signage_count)
		print("ObjectivesHUD: npc_count from FloorController is", npc_count)
	else:
		printerr("FloorController not found! Ensure ObjectivesHUD is a child (or grandchild) of the FloorController.")
		return
	
	# Update the HUD initially
	update_hud_text()

func set_total_objectives_count(signage: int, npcs: int): # CHANGED NAME
	signage_count = signage
	npc_count = npcs
	update_hud_text()

# This function receives the signal
func _on_objective_updated(signage_current: int, signage_total: int, npc_current: int, npc_total: int):
	print("Signal received in Objectives! Signage:", signage_current, "/", signage_total, " NPC:", npc_current, "/", npc_total)
	update_hud_text(signage_current, signage_total, npc_current, npc_total)

func update_hud_text(signage_current: int = 0, signage_total: int = 0, npc_current: int = 0, npc_total: int = 0):
	if signage_label:
		if signage_current >= signage_total:
			signage_label.set("theme_override_colors/default_color", Color("green")) # Make the text green
		else:
			signage_label.set("theme_override_colors/default_color", Color("white")) # set it to default color or whatever you want

		signage_label.text = "Signage: %d/%d" % [signage_current, signage_total]
	else:
		printerr("Error: Signage Label not found in ObjectivesHUD!")

	if npc_label:
		if npc_current >= npc_total:
			npc_label.set("theme_override_colors/default_color", Color("green")) # Make the text green
		else:
			npc_label.set("theme_override_colors/default_color", Color("white")) # set it to default color or whatever you want
		npc_label.text = "NPC: %d/%d" % [npc_current, npc_total]
	else:
		printerr("Error: NPC Label not found in ObjectivesHUD!")
