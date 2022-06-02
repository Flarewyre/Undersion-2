extends Area2D

onready var sprite = $AnimatedSprite
onready var sound = $AudioStreamPlayer2D

export var undersion_path : NodePath
export var move_speed : float
export var aggro_speed : float
export var accel : float

var move_direction : Vector2
var cached_pos : Vector2
var velocity : Vector2
var next_update : float
var update_interval := 1.5
var is_aggro = false
var speed : float

export var rot_speed : float
export var rot_intensity : float

onready var undersion = get_node(undersion_path)

func _ready():
	speed = move_speed

func _physics_process(delta):
	if !is_instance_valid(undersion): return
	
	move_direction.x = (cached_pos.x - global_position.x)
	move_direction.y = (cached_pos.y - global_position.y)
	move_direction = move_direction.normalized()

	var target_velocity = speed * move_direction
	velocity.x = general_util.move_towards(velocity.x, target_velocity.x, accel)
	velocity.y = general_util.move_towards(velocity.y, target_velocity.y, accel)
	
	#if sign(velocity.x) != sign(target_velocity.x):
	#	velocity.x = general_util.move_towards(velocity.x, target_velocity.x, accel * 4)
	#if sign(velocity.y) != sign(target_velocity.y):
	#	velocity.y = general_util.move_towards(velocity.y, target_velocity.y, accel * 4)

	var rot_value = rot_intensity * (velocity.x / aggro_speed)
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, rot_value,  delta * rot_speed)

	var distance = clamp((global_position - undersion.global_position).length(), 0, sound.max_distance)
	sound.pitch_scale = (0.5 - (0.5 * (distance / sound.max_distance))) + 0.2
	
	global_position += velocity * delta
	
	next_update -= delta
	if next_update <= 0:
		next_update = update_interval
		cached_pos = undersion.global_position

func update_aggro(collected, total):
	is_aggro = collected >= ceil(total / 2)
	if is_aggro:
		sprite.play("aggro")
	else:
		sprite.play("idle")
	
	var factor = 0
	if collected > 0:
		factor = collected / total
	var between_speed = aggro_speed - move_speed
	speed = move_speed + (between_speed * factor)
	update_interval = 1.5 - (1.45 * factor)
