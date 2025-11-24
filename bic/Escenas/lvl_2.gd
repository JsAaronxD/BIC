extends Node2D

@export var victory_screen_scene: PackedScene

@onready var hud = $HUD

# Contadores
var normal_fruit_count: int = 0
var second_fruit_count: int = 0
var total_fruit_count: int = 0

func _ready():
	GameManager.save_score_checkpoint()
	
	await get_tree().process_frame
	
	var fruits = get_tree().get_nodes_in_group("fruit")
	var second_fruits = get_tree().get_nodes_in_group("second_fruit")
	
	normal_fruit_count = fruits.size()
	second_fruit_count = second_fruits.size()
	total_fruit_count = normal_fruit_count + second_fruit_count
	
	print("Bananas: %s, Uvas: %s" % [normal_fruit_count, second_fruit_count])

	# Conectamos las señales a sus funciones correctas
	for banana in fruits:
		banana.banana_eaten.connect(_on_normal_fruit_eaten)
	for uva in second_fruits:
		uva.second_fruit_eaten.connect(_on_second_fruit_eaten)
	
	# Desactivamos las uvas
	for uva in second_fruits:
		uva.hide()
		uva.monitoring = false

# Esta función se llama SOLO cuando se come una banana
func _on_normal_fruit_eaten():
	total_fruit_count -= 1
	normal_fruit_count -= 1
	

	# Comprobamos si las frutas NORMALES se acabaron
	if normal_fruit_count <= 0:
		_show_second_fruits()
	
	# Comprobamos si TODAS las frutas se acabaron
	if total_fruit_count <= 0:
		_show_victory_screen()

# Esta función se llama SOLO cuando se come una uva
func _on_second_fruit_eaten():
	total_fruit_count -= 1
	second_fruit_count -= 1

	
	# Si se comen todas las frutas, ganamos
	if total_fruit_count <= 0:
		_show_victory_screen()

func _show_second_fruits():
	print("Mostrando uvas")
	for uva in get_tree().get_nodes_in_group("second_fruit"):
		uva.show()
		uva.monitoring = true

func _show_victory_screen():
	if $HUD.has_method("stop_all_timers"):
		$HUD.stop_all_timers()

	var win_screen = victory_screen_scene.instantiate()
	add_child(win_screen)
