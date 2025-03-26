extends AudioStreamPlayer

var music_player: AudioStreamPlayer = null
var dia_player: AudioStreamPlayer = null

func _ready():
	# Initialize music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"  # Set this to the correct bus name in your Audio Bus layout
	add_child(music_player)

	# Initialize dialogue player
	dia_player = AudioStreamPlayer.new()
	dia_player.bus = "Dialogue"  # Set this to the correct bus name
	add_child(dia_player)

func _play_music(music: AudioStream, volume = 0.0):
	if music_player.stream == music:
		return

	music_player.stream = music
	music_player.volume_db = volume
	music_player.play()

func play_FX(stream: AudioStream, volume=0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.bus = "SFX"  # Make sure this matches the bus name in the Audio tab
	
	# Get current SFX bus volume and apply it
	var sfx_index = AudioServer.get_bus_index("SFX")
	if sfx_index != -1:
		fx_player.volume_db = AudioServer.get_bus_volume_db(sfx_index) + volume
	
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()


func play_DIA(stream: AudioStream, volume=0.0):
	dia_player.stream = stream
	dia_player.volume_db = volume
	dia_player.play()

func stop_DIA():
	if dia_player:
		dia_player.stop()
