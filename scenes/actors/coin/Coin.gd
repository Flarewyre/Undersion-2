extends Area2D

onready var sound = $AudioStreamPlayer
onready var sprite = $AnimatedSprite
onready var particles = $CPUParticles2D
onready var particles2 = $CPUParticles2D2

var collected := false

func collect(shroom):
	if collected or shroom.get_parent().dead: return
	sound.play()
	sprite.visible = false
	particles.emitting = true
	particles2.emitting = false
	collected = true
	get_tree().get_current_scene().get_node("UI").update_coins(get_parent())

func _ready():
	var _connect = connect("area_entered", self, "collect")
