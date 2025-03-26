extends CanvasLayer

const MAX_VOLUME = 2.0  # Increased max volume limit

@onready var master_slider = $ColorRect/Label/master
@onready var bgm_slider = $ColorRect/Label2/BGM
@onready var sfx_slider = $ColorRect/Label3/SFX
@onready var transition_fx = preload("res://BGM/button.mp3")

func _ready() -> void:
	# Debug: Print all available audio buses at runtime
	print("Listing all available audio buses:")
	for i in range(AudioServer.bus_count):
		print("Bus ", i, ": ", AudioServer.get_bus_name(i))
	
	# Check if the "SFX" bus exists
	if AudioServer.get_bus_index("SFX") == -1:
		print("Warning: 'SFX' bus not found! Check your Audio Bus Layout.")
	
	# Set sliders to the current volume levels
	_update_sliders()

func _update_sliders() -> void:
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM")))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func _on_button_pressed() -> void:
	AudioPlayer.play_FX(transition_fx, -12.0)
	queue_free()
	print("CanvasLayer and its children have been removed from the scene tree!")

func _on_master_value_changed(value: float) -> void:
	value = clamp(value, 0.0, MAX_VOLUME)  # Ensure within limits
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	print("Master Volume changed:", value)

func _on_bgm_value_changed(value: float) -> void:
	value = clamp(value, 0.0, MAX_VOLUME)  # Ensure within limits
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(value))
	print("BGM Volume changed:", value)

func _on_sfx_value_changed(value: float) -> void:
	value = clamp(value, 0.0, MAX_VOLUME)  # Ensure within limits
	var volume_db = linear_to_db(value)
	var bus_index = AudioServer.get_bus_index("SFX")

	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, volume_db)
		print("SFX Volume:", value, " dB:", volume_db, " Bus Index:", bus_index)
	else:
		print("Error: SFX bus not found! Make sure it exists in your Audio Bus Layout.")
