extends AudioStreamPlayer

const main_music = preload("res://BGM/Menu.mp3")
const slum_music = preload("res://BGM/slum.mp3")

func _ready():
	# No need to play music on ready since we control it from scenes
	pass

func play_menu_music():
	if not self.playing:
		self.stream = main_music
		self.play()

func stop_music():
	if self.playing:
		self.stop()
		
func play_slum_music():
	if not self.playing:
		self.stream = slum_music
		self.play()

func stop_slum_music():
	if self.playing:
		self.stop_music()
