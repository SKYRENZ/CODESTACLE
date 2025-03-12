extends AudioStreamPlayer


var music_player: AudioStreamPlayer = null
var dia_player: AudioStreamPlayer = null

func _ready():
	# Initialize music player
	
	# Initialize dialogue player
	dia_player = AudioStreamPlayer.new()
	dia_player.stream = null
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
	fx_player.volume_db = volume
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
