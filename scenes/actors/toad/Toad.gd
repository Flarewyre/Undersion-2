extends Area2D

onready var sprite = $AnimatedSprite
onready var particles = $Particles
onready var explosion = $Explosion
onready var sound = $AudioStreamPlayer
onready var bubbles = $CPUParticles2D

var og_Y_pos : float
var elapsed : float
var dead : bool

func _ready():
	og_Y_pos = position.y
	connect("area_entered", self, "die")

func _physics_process(delta):
	if dead: return
	elapsed += delta
	position.y = og_Y_pos + (sin(elapsed) * 16)

func die(shroom):
	if dead or !shroom.get_parent().attacking or shroom.get_parent().dead: return
	sound.play()
	get_tree().get_current_scene().get_node("Camera2D").zoom = Vector2(0.75, 0.75)
	yield(get_tree(), "physics_frame")
	pause_mode = PAUSE_MODE_PROCESS
	dead = true
	bubbles.emitting = false
	explosion.visible = true
	explosion.playing = true
	get_tree().paused = true
	yield(get_tree().create_timer(0.15), "timeout")
	get_tree().paused = false
	sprite.visible = false
	for particle in particles.get_children():
		particle.emitting = true 
	pause_mode = PAUSE_MODE_INHERIT
	get_tree().get_current_scene().get_node("UI").update_toads(get_parent())
