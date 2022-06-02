extends CanvasLayer

onready var anim_player = $AnimationPlayer
var pressed = false
var appeared = false

func win():
	appeared = true
	get_tree().paused = true
	anim_player.play("in")

func _input(event):
	if !appeared or pressed: return
	if event.is_action_pressed("ui_accept"):
		pressed = true
		GameInfo.cur_level += 1
		SceneTransitions.transition_in()
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().paused = false
		if GameInfo.cur_level <= 3:
			get_tree().change_scene("res://scenes/briefs/briefing.tscn")
		else:
			get_tree().change_scene("res://scenes/endscreen.tscn")
	if event.is_action_pressed("reset"):
		pressed = true
		SceneTransitions.transition_in()
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().paused = false
		get_tree().reload_current_scene()
