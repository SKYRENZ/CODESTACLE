extends AudioStreamPlayer

const main_music = preload("res://BGM/Menu.mp3")
const slum_music = preload("res://BGM/slum.mp3")

func _ready():
	self.bus = "BGM"  # Make sure this player is on the correct audio bus

func play_menu_music():
	if self.stream != main_music or not self.playing:
		self.stop()  # Stop any currently playing track
		self.stream = main_music
		self.play()
		print("Playing Menu Music")

func play_slum_music():
	if self.stream != slum_music or not self.playing:
		self.stop()  # Stop any currently playing track
		self.stream = slum_music
		self.play()
		print("Playing Slum Music")

func stop_music():
	if self.playing:
		self.stop()
		print("Music Stopped")
