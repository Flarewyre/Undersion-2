extends Area2D

onready var sprite = $AnimatedSprite
onready var magnet = $Magnet
onready var particles = $CPUParticles2D

export var attract_speed : float
var delete_time : float
var collected : bool

func _physics_process(delta):
	if delete_time > 0:
		delete_time -= delta
		if delete_time < 0:
			queue_free()

	if collected: return
	for body in magnet.get_overlapping_bodies():
		global_position = global_position.move_toward(body.global_position, delta * attract_speed)

func _ready():
	connect("body_entered", self, "collect")

func collect(shroom):
	if collected or shroom.dead: return
	collected = true
	sprite.visible = false
	particles.emitting = true
	Music.play_energy_sound()
	get_tree().get_current_scene().get_node("UI").energy_collected += 1
	get_tree().get_current_scene().get_node("UI").update_energy()
	delete_time = 3
