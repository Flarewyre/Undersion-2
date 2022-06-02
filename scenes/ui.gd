extends CanvasLayer

onready var coin_ui = $CoinUI
onready var coin_text = $CoinUI/Value
onready var coin_text_2 = $CoinUI/Value2
onready var coin_y : float

onready var toad_ui = $ToadUI
onready var toad_text = $ToadUI/Value
onready var toad_text_2 = $ToadUI/Value2
onready var toad_y : float

onready var energy_ui = $EnergyUI
onready var energy_text = $EnergyUI/Value
onready var energy_text_2 = $EnergyUI/Value2
onready var energy_y : float

onready var timer_text = $Timer/Value
onready var timer_text_2 = $Timer/Value2

var coins_collected : int
var coin_anim_timer : float

var toads_killed : int
var toad_anim_timer : float

var energy_collected : int
var energy_anim_timer : float

var timer : float

func _ready():
	coin_y = coin_ui.rect_position.y
	toad_y = toad_ui.rect_position.y
	energy_y = energy_ui.rect_position.y
	
	update_coins(get_tree().get_current_scene().get_node("Coins"))
	update_toads(get_tree().get_current_scene().get_node("Toads"))

func update_coins(coins_group : Node2D):
	var i = 0
	for coin in coins_group.get_children():
		if coin.collected:
			i += 1
	coins_collected = i
	
	coin_text.bbcode_text = str(i) + "/" + str(coins_group.get_children().size())
	coin_text_2.bbcode_text = coin_text.bbcode_text
	
	if i == coins_group.get_children().size():
		get_tree().get_current_scene().get_node("Star").appear()
	
	coin_ui.rect_position.y = coin_y - 3
	coin_anim_timer = 0.15
	
	if i > 0 and is_instance_valid(get_tree().get_current_scene().get_node("GreenDemon")):
		get_tree().get_current_scene().get_node("GreenDemon").update_aggro(i, coins_group.get_children().size())

func update_toads(toads_group : Node2D):
	var i = 0
	for toad in toads_group.get_children():
		if toad.dead:
			i += 1
	toads_killed = i
	
	toad_text.bbcode_text = str(i) + "/" + str(toads_group.get_children().size())
	toad_text_2.bbcode_text = toad_text.bbcode_text
	
	toad_ui.rect_position.y = toad_y - 3
	toad_anim_timer = 0.15

func update_energy():
	energy_text.bbcode_text = str(energy_collected)
	energy_text_2.bbcode_text = energy_text.bbcode_text
	
	energy_ui.rect_position.y = energy_y - 3
	energy_anim_timer = 0.15

func update_timer(t):
	var minutes = int(t / 60 / 1000)
	var seconds = int(t / 1000) % 60
	var miliseconds = int(t) % 1000

	var time = ("%02d" % minutes) + (":%02d" % seconds) + (":%03d" % miliseconds)
	time[time.length() - 1] = ""
	timer_text.bbcode_text = "[right]" + time + "[/right]"
	timer_text_2.bbcode_text = timer_text.bbcode_text

func _physics_process(delta):
	coin_anim_timer = general_util.move_towards(coin_anim_timer, 0, delta)
	if coin_anim_timer <= 0:
		coin_ui.rect_position.y = general_util.move_towards(
			coin_ui.rect_position.y, 
			coin_y, 
			-(coin_ui.rect_position.y - coin_y) / 3
		)

	toad_anim_timer = general_util.move_towards(toad_anim_timer, 0, delta)
	if toad_anim_timer <= 0:
		toad_ui.rect_position.y = general_util.move_towards(
			toad_ui.rect_position.y, 
			toad_y, 
			-(toad_ui.rect_position.y - toad_y) / 3
		)

	energy_anim_timer = general_util.move_towards(energy_anim_timer, 0, delta)
	if energy_anim_timer <= 0:
		energy_ui.rect_position.y = general_util.move_towards(
			energy_ui.rect_position.y, 
			energy_y, 
			-(energy_ui.rect_position.y - energy_y) / 3
		)

	timer += delta * 1000
	update_timer(timer)
