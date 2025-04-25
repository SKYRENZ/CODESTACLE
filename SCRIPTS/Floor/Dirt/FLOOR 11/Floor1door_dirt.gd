extends Node2D

@export var floor_number: int = 11
@export var target_scene: String = "res://SCENES/FLOOR/Dirt/Floor 1 Dirt.tscn"  # Target scene to load
@export var scene_intro_dirt = preload("res://SCENES/Transitions/SceneIntroDirt.tscn")  # Path to SceneIntroDirt
@onready var inventory = $UI/Validation  # Reference to Inventory UI
@onready var player = get_node("CharacterBody2D")

var interactable_items: Array = []  # Store all interactable items in range
var player_in_area = false  # Track if the player is in the door area

func _ready():
	print("🟢 Current Floor Number:", floor_number)
	
	# Fetch Floor Data if available
	if FloorData.has_method("get_floor_data"):
		var floor_data = FloorData.get_floor_data(floor_number)
		print("📜 Loaded Floor Data:", floor_data)

	if player:
		var spawn_point = get_node("Marker2D")
		if spawn_point:
			player.spawn_point = spawn_point
			print("✅ Initial spawn point set at:", spawn_point.global_position)
		else:
			print("❌ Error: Default spawn Marker2D not found!")

		# Connect all checkpoints
		var checkpoints = get_tree().get_nodes_in_group("checkpoint")
		print("🟢 Found checkpoints:", checkpoints.size())

		for checkpoint in checkpoints:
			if checkpoint is Area2D:
				checkpoint.connect("body_entered", _on_checkpoint_reached)
				print("🔹 Checkpoint connected:", checkpoint.name)
		
		# Hide inventory initially
		if inventory:
			inventory.visible = false
	else:
		print("❌ Error: Player not found!")

func _process(_delta):
	# Detect when the player presses "interact" (e.g., "E") near the door
	if Input.is_action_just_pressed("interact") and player_in_area:
		print("🟢 Player interacted with the door. Playing SceneIntroDirt...")
		_play_scene_intro_dirt()

# Detect when the player enters the door area
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		print("🟢 Player entered the door area.")

# Detect when the player exits the door area
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		print("⚪ Player exited the door area.")

# Play the SceneIntroDirt animation before transitioning to the new floor
func _play_scene_intro_dirt():
	print("🎬 Playing SceneIntroDirt...")
	var scene_intro_instance = scene_intro_dirt.instantiate()
	get_tree().root.add_child(scene_intro_instance)  # Add SceneIntroDirt to the root of the scene tree

	# Connect the intro_finished signal to transition to the new floor after the intro
	scene_intro_instance.intro_finished.connect(Callable(self, "_change_scene"))

# Change to the target scene (Floor 11)
func _change_scene():
	print("🔄 Changing to scene:", target_scene)
	if ResourceLoader.exists(target_scene):
		get_tree().change_scene_to_file(target_scene)
	else:
		printerr("❌ Error: Target scene does not exist:", target_scene)

# Checkpoint system
func _on_checkpoint_reached(body):
	if body.is_in_group("player"):
		var checkpoint = body.get_parent()
		var spawn_marker = checkpoint.find_child("Spawnpoint", true, false)

		if spawn_marker:
			body.spawn_point = spawn_marker
			print("✅ Checkpoint reached! New spawn:", spawn_marker.global_position)
		else:
			print("❌ ERROR: 'Spawnpoint' missing in Checkpoint!")
