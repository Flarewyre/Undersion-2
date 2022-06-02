extends Node2D

func _ready():
	Music.load_music("res://scenes/title.ogg", -5)
	yield(get_tree().create_timer(0.4), "timeout")
	SceneTransitions.transition_out()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		GameInfo.cur_level = 1
		SceneTransitions.transition_in()
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene("res://scenes/Title.tscn")
