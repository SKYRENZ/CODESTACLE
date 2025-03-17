extends Control

@onready var sentence_label = $Panel/Label
@onready var vbox_container = $Panel/VBoxContainer
@onready var validation_panel = $Panel  

@export var font_resource: Font  
@export var background_image: Texture  

var sentence_template = []
var valid_items = []
var collected_items = []  
var next_expected_index = 0  
var current_floor  

func _ready():
	await get_tree().process_frame  

	var floor_node = get_tree().get_first_node_in_group("floor")

	if floor_node:
		if floor_node.has_method("get_meta") and floor_node.has_meta("floor_number"):
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
	if floor_data:
		sentence_template = floor_data.sentence_template
		valid_items = floor_data.valid_items
		print("✅ Loaded Floor Data:", floor_data)
	else:
		print("⚠️ Warning: No data found for floor ", current_floor)
