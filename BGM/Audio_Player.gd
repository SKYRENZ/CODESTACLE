extends AudioStreamPlayer

const main_music = preload("res://BGM/Menu.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_music_main():
	_play_music(main_music)
