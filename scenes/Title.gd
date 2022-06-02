extends Node2D

onready var label = $RichTextLabel
onready var label2 = $RichTextLabel2
onready var sound = $AudioStreamPlayer

var wait_time := 0.5
var countdown := 0
var pressed : bool

func _ready():
	Music.load_music("res://scenes/title.ogg", -5)
	
	if SceneTransitions.is_in:
		yield(get_tree().create_timer(0.4), "timeout")
		SceneTransitions.transition_out()

func _physics_process(delta):
	wait_time = general_util.move_towards(wait_time, 0, delta)
	if wait_time <= 0 and !pressed:
		label.modulate.a = lerp(label.modulate.a, 1, delta * 4)
	
	countdown -= 1
	if countdown <= 0:
		countdown = 32 if !pressed else 3
		label.modulate.r = 1 if label.modulate.r == 0.75 else 0.75
		label.modulate.g = (label.modulate.r + label.modulate.b) / 2
		label.modulate.b = 1
		
		if pressed:
			label.modulate.a = 0 if label.modulate.r == 0.75 else 1
	
	label2.modulate = label.modulate

func _input(event):
	if pressed: return
	if event.is_action_pressed("ui_accept"):
		sound.play()
		countdown = 3
		pressed = true
		yield(get_tree().create_timer(1.5), "timeout")
		SceneTransitions.transition_in()
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene("res://scenes/briefs/briefing.tscn")
