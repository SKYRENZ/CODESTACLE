extends CanvasLayer

@onready var progress_bar: ProgressBar = $ProgressBar # Ensure this matches the child node's name

func update_progress(value: float):
	if progress_bar:
		progress_bar.value = value * 100 # Ensure the ProgressBar's range is 0-100
		print("Progress bar updated to:", value * 100)
	else:
		print("Error: Progress bar node not found!")
