extends Path2D

@export var loop = true
@export var speed = 0.5  # Adjusted speed for smoother movement
@export var speed_scale = 1.0

@onready var path_follow = $PathFollow2D
@onready var animation = $AnimationPlayer  

func _ready():
	if not loop:
		animation.play("move")
		animation.speed_scale = speed_scale
		set_process(false)

func _process(delta):
	path_follow.progress_ratio += speed * delta * 0.1  # Adjust this factor for finer speed control
