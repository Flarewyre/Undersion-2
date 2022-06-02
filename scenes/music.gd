extends AudioStreamPlayer

onready var energy = $Energy
onready var tween = Tween.new()

var cur_song := ""
var volume_level : float
var muted : bool

func _ready():
	tween.pause_mode = PAUSE_MODE_PROCESS
	add_child(tween)

func load_music(music : String, volume : float = 1):
	if music != cur_song:
		cur_song = music
		stream = load(cur_song)
		volume_level = volume
		#volume_db = volume_level if !muted else -80
		play()

func _input(event):
	if event.is_action_pressed("mute"):
		muted = !muted
		volume_db = volume_level if !muted else -80

func play_energy_sound():
	energy.play()

func fade_out():
	tween.interpolate_property(
		self, 
		"volume_db", 
		volume_level if !muted else -80, 
		-80, 
		0.55, 
		Tween.TRANS_QUINT, 
		Tween.EASE_IN
	)
	tween.start()

func fade_in():
	tween.interpolate_property(
		self, 
		"volume_db", 
		-80, 
		volume_level if !muted else -80, 
		0.55, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	tween.start()
