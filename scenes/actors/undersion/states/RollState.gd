extends State

class_name RollState

export var boost_power : float
var next_press : float
var key_to_press : String

var stop_time : float
var direction : Vector2
var rotation : float

var direction_map = {
	"move_left": Vector2(-1, 0),
	"move_right": Vector2(1, 0),
	"move_up": Vector2(0, -1),
	"move_down": Vector2(0, 1)
}

func _ready():
	override_rotation = true
	is_attack = true

func _start_check(_delta: float):
	return key_to_press != "" and Input.is_action_just_pressed(key_to_press)
	
func _start(_delta: float):
	$AudioStreamPlayer.play()
	character.sprite.play("attack")
	
	key_to_press = ""
	if direction.x != 0:
		character.velocity.x = direction.x * boost_power
		rotation = -360 * sign(direction.x)
	elif direction.y != 0:
		character.velocity.y = direction.y * boost_power
		var velocity_direction = sign(character.velocity.x)
		if velocity_direction == 0:
			velocity_direction = 1
		rotation = 360 * (sign(-direction.y) * velocity_direction)
	
	stop_time = 0.5
	
# called every frame only when the state is active
func _update(delta: float):
	rotation = lerp(rotation, character.velocity.x / (character.move_speed / character.rot_intensity), delta * 4)
	character.sprite.rotation_degrees = rotation
	stop_time = general_util.move_towards(stop_time, 0, delta)
	
	# le bouncy
	if stop_time > 0.1:
		if direction.x == 1 and character.is_wall_right(abs(character.velocity.x * delta)):
			direction.x = -1
			_start(delta)
			character.velocity.x /= 2

			rotation = -180 * sign(direction.x)
		if direction.x == -1 and character.is_wall_left(abs(character.velocity.x * delta)):
			direction.x = 1
			_start(delta)
			character.velocity.x /= 2

			rotation = -180 * sign(direction.x)
	
		if direction.y == 1 and character.is_grounded(abs(character.velocity.y * delta)):
			direction.y = -1
			_start(delta)
			character.velocity.y /= 2
			
			var velocity_direction = sign(character.velocity.x)
			if velocity_direction == 0:
				velocity_direction = 1
			rotation = 180 * (sign(-direction.y) * velocity_direction)
		if direction.y == -1 and character.is_ceiling(abs(character.velocity.y * delta)):
			direction.y = 1
			_start(delta)
			character.velocity.y /= 2
			
			var velocity_direction = sign(character.velocity.x)
			if velocity_direction == 0:
				velocity_direction = 1
			rotation = 180 * (sign(-direction.y) * velocity_direction)

func _stop(_delta: float):
	character.sprite.play("default")
	
func _stop_check(_delta: float):
	return stop_time <= 0
	
# called every frame regardless of if the state is active
func _general_update(delta: float):
	var was_pressed = key_to_press != "";
	
	if Input.is_action_just_pressed("move_left"):
		key_to_press = "move_left"
	if Input.is_action_just_pressed("move_right"):
		key_to_press = "move_right"
	if Input.is_action_just_pressed("move_up"):
		key_to_press = "move_up"
	if Input.is_action_just_pressed("move_down"):
		key_to_press = "move_down"
	
	if key_to_press != "" and !was_pressed:
		direction = direction_map[key_to_press]
		next_press = 0.225
	
	next_press = general_util.move_towards(next_press, 0, delta)
	if next_press <= 0:
		key_to_press = ""
