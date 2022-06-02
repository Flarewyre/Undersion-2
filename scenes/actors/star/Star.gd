extends Area2D

export var camera_path : NodePath
onready var camera = get_node(camera_path)

var og_cam_pos : Vector2
var appeared = false

onready var animation_player = $AnimationPlayer

func appear():
	appeared = true
	
	pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true
	og_cam_pos = camera.position
	
	SceneTransitions.transition_in()
	yield(get_tree().create_timer(0.5), "timeout")
	camera.position = global_position
	animation_player.play("appear")
	SceneTransitions.transition_out()
	yield(animation_player, "animation_finished")
	
	SceneTransitions.transition_in()
	yield(get_tree().create_timer(0.5), "timeout")
	camera.position = og_cam_pos
	SceneTransitions.transition_out()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().paused = false

func _ready():
	connect("area_entered", self, "win")

func win(shroom):
	if !appeared or shroom.get_parent().dead: return
	get_tree().get_current_scene().get_node("Ranking").win()
