# CodePopup.gd
extends CanvasLayer

func _ready():
	# Connect CloseButton (do this in editor instead if preferred)
	$CloseButton.pressed.connect(self.hide)
