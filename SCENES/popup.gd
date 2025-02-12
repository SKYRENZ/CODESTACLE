extends Node2D

@onready var label = $Label
@onready var anim = $AnimationPlayer  # First AnimationPlayer
@onready var anim2 = $AnimationPlayer2  # Second AnimationPlayer
@onready var area = $Area2D
@onready var area2 = $Area2D2

func _ready():
	print("Animations available (AnimationPlayer):", anim.get_animation_list())  # Debugging
	print("Animations available (AnimationPlayer2):", anim2.get_animation_list())  # Debugging

	label.visible = false
	area.body_entered.connect(_on_body_entered)
	area2.body_entered.connect(_on_body_entered2)  # Connect second Area2D

func _on_body_entered(_body):
	print("Playing animation: nalabas")
	label.visible = true  
	anim.play("nalabas")  
	print("AnimationPlayer playing:", anim.is_playing())  

func _on_body_entered2(_body):
	print("Playing animation: jumping")
	label.visible = true  
	anim2.play("jumping")  
	print("AnimationPlayer2 playing:", anim2.is_playing())  
