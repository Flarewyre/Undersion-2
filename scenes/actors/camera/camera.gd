extends Camera2D

export var character : NodePath
var focus_on : Node
var focus_zoom := 1.0

onready var character_node = get_node(character)

var character_vel = Vector2(0, 0)
func _physics_process(delta):
	if is_instance_valid(character_node):
		if character_node.controllable:
			character_vel = character_vel.linear_interpolate(character_node.velocity * 15.5 * delta, delta * 2)
		else:
			character_vel = Vector2()
		
		position = character_node.global_position + character_vel
	zoom.x = lerp(zoom.x, 1.0, delta * 2)
	zoom.y = lerp(zoom.y, 1.0, delta * 2)
