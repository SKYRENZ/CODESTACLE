extends Path2D

@export var speed = 0.5  # Adjust speed as needed

@onready var path_follow = $PathFollow2D
@onready var animation = $AnimationPlayer

var direction = 1  # 1 = forward, -1 = backward

func _ready():
	pass

func _process(delta):
	path_follow.progress_ratio += speed * delta * direction  

	# Reverse direction when reaching the start or end
	if path_follow.progress_ratio >= 1.0:
		direction = -1  # Move backward
	elif path_follow.progress_ratio <= 0.0:
		direction = 1  # Move forward
