extends Node2D

var transition_time = 0.4
var transitioning = false
var is_in = false

func transition_in():
	if transitioning: return
	
	is_in = true
	transitioning = true
	
	Music.fade_out()
	
	var animation_player = $AnimationPlayer
	animation_player.play("in")
	
	transitioning = false

func transition_out():
	if transitioning: return
	
	is_in = false
	transitioning = true
	
	Music.fade_in()
	
	var animation_player = $AnimationPlayer
	animation_player.play("out")
	
	transitioning = false
