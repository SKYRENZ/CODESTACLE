# PressurePlate.gd
extends Area2D

@export var answer: String  # The answer this pressure plate represents

signal plate_activated(answer)

@onready var animation = $AnimatedSprite2D  # Animation for the pressure plate

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))  # Connect the body_entered signal
	connect("body_exited", Callable(self, "_on_body_exited"))  # Connect the body_exited signal
	animation.play("idle")  # Start with the idle animation

func _on_body_entered(body):
	if body.is_in_group("player"):  # Check if the body belongs to the "player" group
		print("✅ Player stepped on the plate: %s" % answer)
		animation.play("pressed")  # Play the pressed animation
		emit_signal("plate_activated", answer)  # Emit the signal with the answer
		print("Signal emitted with answer: %s" % answer)  # Debugging

func _on_body_exited(body):
	if body.is_in_group("player"):  # Check if the body belongs to the "player" group
		print("⬅️ Player left the plate.")
		animation.play("idle")  # Return to the idle animation
