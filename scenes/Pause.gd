extends CanvasLayer

onready var control = $Control
var paused = false

func toggle_pause():
	if get_tree().paused and !paused: return
	paused = !paused
	get_tree().paused = paused

func _input(event):
	if event.is_action_pressed("pause") and !get_tree().get_current_scene().get_node("Undersion").dead:
		toggle_pause()

func _physics_process(delta):
	var target = 0 if paused else -288
	var speed = clamp(((abs(control.rect_position.y - target) + 16) / 288) * 32, 0, 32)
	control.rect_position.y = general_util.move_towards(control.rect_position.y, target, speed)
