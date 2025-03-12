extends Node2D

@onready var label = $Label
@onready var anim = $AnimationPlayer  
@onready var anim2 = $AnimationPlayer2  
@onready var anim3 = $AnimationPlayer3  

@onready var area = $"walking trigger"
@onready var area2 = $"jumping trigger"
@onready var area3 = $"climb trigger"

@onready var exit_area_walking = $"exit area_walking"  
@onready var exit_area_jumping = $"exit area_jumping"
@onready var exit_area_climbing = $"exit area_climbing"

func _ready():
	MenuMusic.stop_music()	
	print("Animations available (AnimationPlayer):", anim.get_animation_list())  
	print("Animations available (AnimationPlayer2):", anim2.get_animation_list())  
	print("Animations available (AnimationPlayer3):", anim3.get_animation_list())  

	label.visible = false
	
	# Connect triggers
	area.body_entered.connect(_on_body_entered)
	area2.body_entered.connect(_on_body_entered2)  
	area3.body_entered.connect(_on_body_entered3)  

	# Connect exits
	exit_area_walking.body_entered.connect(_on_exit_walking)  
	exit_area_jumping.body_entered.connect(_on_exit_jumping)
	exit_area_climbing.body_entered.connect(_on_exit_climbing)


# Walking animation trigger
func _on_body_entered(_body):
	print("Playing animation: nalabas (walking)")
	label.visible = true  
	anim.play("nalabas")  
	print("AnimationPlayer playing:", anim.is_playing())  

# Jumping animation trigger
func _on_body_entered2(_body):
	print("Playing animation: jumping")
	label.visible = true  
	anim2.play("jumping")  
	print("AnimationPlayer2 playing:", anim2.is_playing())  

# Climbing animation trigger
func _on_body_entered3(_body):
	print("Playing animation: akyat (climbing)")
	label.visible = true  
	anim3.play("akyat")  
	print("AnimationPlayer3 playing:", anim3.is_playing())  

# Walking exit
func _on_exit_walking(_body):
	print("Exited through walking area!")
	label.visible = false  
	anim.stop()  

# Jumping exit
func _on_exit_jumping(_body):
	print("Exited through jumping area!") 
	label.visible = false  
	anim2.stop()  

# Climbing exit
func _on_exit_climbing(_body):
	print("Exited through climbing area!")  
	label.visible = false  
	anim3.stop()
