extends CanvasLayer

@onready var coin_label: Label = $Label  # Reference to the Label node

func update_coin_count(count: int) -> void:
	coin_label.text = str(count)  # Update the Label text
