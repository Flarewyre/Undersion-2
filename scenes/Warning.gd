extends CanvasLayer

onready var sprite = $Sprite

export var x_center : float
export var x_addition : float

export var y_center : float
export var y_addition : float

export var camera_path : NodePath
onready var camera = get_node(camera_path)

export var demon_path : NodePath
onready var demon = get_node(demon_path)

func _physics_process(delta):
	var distance = (demon.global_position - camera.global_position)
	var normal = distance.normalized()
	if abs(normal.x) > abs(normal.y):
		normal.x = sign(normal.x)
	else:
		normal.y = sign(normal.y)
	
	sprite.position.x = x_center + (x_addition * normal.x)
	sprite.position.y = y_center + (y_addition * normal.y)

	distance.x = abs(clamp(distance.x, 0, 768))
	distance.y = abs(clamp(distance.y, 0, 768))

	sprite.scale.x = abs((768 - distance.length()) / 384)
	sprite.scale.y = sprite.scale.x

	var distance_median = (distance.x + distance.y) / 2 
	if distance_median < x_addition + 96:
		sprite.modulate.a = (distance_median / (x_addition + 96))
	else:
		sprite.modulate.a = 1
