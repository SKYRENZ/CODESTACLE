extends CanvasLayer

@onready var progress_bar: ProgressBar = $ProgressBar

var player: Node2D = null
var door: Node2D = null
var max_distance: float = 0.0

func _ready():
	# Get references to the player and door
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().has_group("player") else null
	door = get_tree().get_nodes_in_group("door")[0] if get_tree().has_group("door") else null

	if player and door:
		# Calculate the maximum distance (initial distance between player and door)
		max_distance = player.global_position.distance_to(door.global_position)
	else:
		printerr("Player or Door not found in the scene!")

func _process(delta):
	if player and door:
		# Calculate the current distance
		var current_distance = player.global_position.distance_to(door.global_position)
		
		# Normalize the progress (1 when farthest, 0 when at the door)
		var progress = clamp(1.0 - (current_distance / max_distance), 0.0, 1.0)
		
		# Update the progress bar
		progress_bar.value = progress * 100

func update_progress(progress: float) -> void:
	progress_bar.value = clamp(progress * 100, 0, 100)
