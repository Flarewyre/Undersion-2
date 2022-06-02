extends KinematicBody2D
class_name Undersion

# nodes
onready var sprite = $AnimatedSprite
onready var states_node = $States
onready var demon_detector = $DemonDetector
onready var death_particles = $DeathParticles
onready var death_sound = $DeathSound
onready var explosion = $Explosion
onready var bubbles1 = $CPUParticles2D
onready var bubbles2 = $CPUParticles2D2
onready var afterimage = $CPUParticles2D3

# physics
var velocity : Vector2
export var move_speed : float
export var acceleration : float
export var deceleration : float
export var friction : float

export var rot_speed : float
export var rot_intensity : float
export var bump_thres : float

# states
var state : Node = null
var last_state : Node = null
var switching_state := false
var controllable := true
var attacking := false
var dead := false

# collision
var last_ceiling : bool
var last_grounded : bool
var last_wall_left : bool
var last_wall_right : bool

func is_ceiling(magnitude:float = 0.5):
	return test_move(global_transform, Vector2(0, -magnitude))

func is_grounded(magnitude:float = 0.5):
	return test_move(global_transform, Vector2(0, magnitude))

func is_wall_left(magnitude:float = 0.5):
	return test_move(global_transform, Vector2(-magnitude, 0))
	
func is_wall_right(magnitude:float = 1):
	return test_move(global_transform, Vector2(magnitude, 0))

#
func _ready():
	Music.load_music("res://scenes/levels/level1/track.ogg", -4)
	var _connect = demon_detector.connect("area_entered", self, "touch_demon")
	yield(get_tree().create_timer(0.4), "timeout")
	SceneTransitions.transition_out()
	
	sprite.play("default")

func touch_demon(_demon):
	die()

func die():
	if dead: return
	death_sound.play()
	get_tree().get_current_scene().get_node("Camera2D").zoom = Vector2(0.75, 0.75)
	yield(get_tree(), "physics_frame")
	pause_mode = PAUSE_MODE_PROCESS
	dead = true
	controllable = false
	bubbles1.emitting = false
	bubbles2.emitting = false
	afterimage.emitting = false
	explosion.visible = true
	explosion.playing = true
	get_tree().paused = true
	yield(get_tree().create_timer(0.15), "timeout")
	get_tree().paused = false
	sprite.visible = false
	for particle in death_particles.get_children():
		particle.emitting = true 
	pause_mode = PAUSE_MODE_INHERIT
	yield(get_tree().create_timer(1), "timeout")

	SceneTransitions.transition_in()
	yield(get_tree().create_timer(0.5), "timeout")
	var _scene = get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("reset"):
		die()
#

# general logic
func _physics_process(delta):
	if get_tree().paused: return
	var move_vector : Vector2
	
	# inputs
	if controllable:
		if Input.is_action_pressed("move_left"):
			move_vector.x -= 1
		if Input.is_action_pressed("move_right"):
			move_vector.x += 1
			
		if Input.is_action_pressed("move_up"):
			move_vector.y -= 1
		if Input.is_action_pressed("move_down"):
			move_vector.y += 1
	#
	
	# movement
	if abs(velocity.x) <= move_speed:
		if move_vector.x != 0:
			velocity.x = general_util.move_towards(velocity.x, move_vector.x * move_speed, acceleration)
		else:
			velocity.x = general_util.move_towards(velocity.x, 0, friction)
	else:
		var decel = deceleration
		if sign(move_vector.x) == sign(velocity.x):
			decel /= 3
		elif sign(move_vector.x) == sign(-velocity.x):
			decel *= 2
			
		velocity.x = general_util.move_towards(velocity.x, move_vector.x * move_speed, decel)
		
		
	if abs(velocity.y) <= move_speed:
		if move_vector.y != 0:
			velocity.y = general_util.move_towards(velocity.y, move_vector.y * move_speed, acceleration)
		else:
			velocity.y = general_util.move_towards(velocity.y, 0, friction)
	else:
		var decel = deceleration
		if sign(move_vector.y) == sign(velocity.y):
			decel /= 3
		elif sign(move_vector.y) == sign(-velocity.y):
			decel *= 2
		
		velocity.y = general_util.move_towards(velocity.y, move_vector.y * move_speed, decel)
	#
	
	# le bouncy
	if velocity.x > bump_thres and is_wall_right(abs(velocity.x * delta)) and !last_wall_right:
		velocity.x = -velocity.x / 2

	if velocity.x < -bump_thres and is_wall_left(abs(velocity.x * delta)) and !last_wall_left:
		velocity.x = -velocity.x / 2

	if velocity.y > bump_thres and is_grounded(abs(velocity.y * delta)) and !last_grounded:
		velocity.y = -velocity.y / 2

	if velocity.y < -bump_thres and is_ceiling(abs(velocity.y * delta)) and !last_ceiling:
		velocity.y = -velocity.y / 2
	
	last_wall_right = is_wall_right(abs(velocity.x * delta))
	last_wall_left = is_wall_left(abs(velocity.x * delta))
	last_ceiling = is_ceiling(abs(velocity.y * delta))
	last_grounded = is_grounded(abs(velocity.y * delta))
	#
	
	for state_node in states_node.get_children():
		state_node.handle_update(delta)
	
	if state != null:
		attacking = state.is_attack
	else:
		attacking = false
	
	if state == null or !state.override_rotation:
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, velocity.x / (move_speed / rot_intensity), delta * rot_speed)
	velocity = move_and_slide(velocity)
#

# states
func set_state(new_state: Node, delta: float) -> void:
	last_state = state
	state = null
	if is_instance_valid(last_state):
		last_state._stop(delta)
	if is_instance_valid(new_state):
		state = new_state
		new_state._start(delta)
	#emit_signal("state_changed", new_state, last_state)

func get_state_node(name: String) -> Node:
	if states_node.has_node(name):
		return states_node.get_node(name)
	return null

func set_state_by_name(name: String, delta: float = 0.0001) -> void:
	if is_instance_valid(get_state_node(name)):
		set_state(get_state_node(name), delta)
#
