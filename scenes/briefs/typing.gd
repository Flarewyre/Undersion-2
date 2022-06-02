extends Node2D

onready var day_1 = $Day
onready var day_2 = $Day2
onready var label_1 = $RichTextLabel
onready var label_2 = $RichTextLabel2
onready var sound = $AudioStreamPlayer

var text : String
var countdown := 2
var typing_countdown := 0.5

func _ready():
	Music.load_music("res://scenes/briefs/music.ogg", -1.5)
	text = get_node("Briefing" + str(GameInfo.cur_level)).bbcode_text
	label_1.text = ""
	label_2.text = ""
	day_1.bbcode_text = "Day " + str(GameInfo.cur_level)
	day_2.bbcode_text = day_1.bbcode_text
	yield(get_tree().create_timer(0.4), "timeout")
	SceneTransitions.transition_out()

func _physics_process(delta):
	typing_countdown -= delta
	if typing_countdown > 0: return

	countdown -= 1
	if countdown <= 0:
		countdown = 2
		if text != "" and label_1.text.length() != text.length():
			if text[label_1.text.length()] == "":
				countdown = 0
			elif text[label_1.text.length()] == ".":
				countdown = 16
			elif text[label_1.text.length()] == "!":
				countdown = 16
			elif text[label_1.text.length()] == ",":
				countdown = 16
			else:
				sound.play()
			label_1.text += text[label_1.text.length()] 
			label_2.text = label_1.text

func _input(event):
	if event.is_action_pressed("ui_accept"):
		SceneTransitions.transition_in()
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene("res://scenes/levels/level" + str(GameInfo.cur_level) + "/level.tscn")
