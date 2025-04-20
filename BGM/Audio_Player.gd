extends AudioStreamPlayer

var music_player: AudioStreamPlayer = null
var dia_player: AudioStreamPlayer = null
var coin_player: AudioStreamPlayer = null  # 🪙 Coin player

func _ready():
	# Initialize music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

	# Initialize dialogue player
	dia_player = AudioStreamPlayer.new()
	dia_player.bus = "SFX"
	add_child(dia_player)

	# Initialize coin SFX player
	coin_player = AudioStreamPlayer.new()
	coin_player.bus = "SFX"
	add_child(coin_player)

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
	fx_player.bus = "SFX"

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

# 🪙 Coin Sound Effect
func play_coin_sfx(stream: AudioStream, volume=0.0):
	coin_player.stream = stream
	coin_player.volume_db = volume
	coin_player.play()
