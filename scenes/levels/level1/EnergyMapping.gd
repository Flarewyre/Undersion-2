extends TileMap

onready var energy_scene = preload("res://scenes/actors/energy/Energy.tscn")

func _ready():
	for cell in get_used_cells():
		set_cell(cell.x, cell.y, -1)
		var energy = energy_scene.instance()
		energy.position.x = (cell.x * 24) + 6
		energy.position.y = (cell.y * 24) + 6
		add_child(energy)
