extends CanvasLayer

# Esta señal le avisará al nivel que debe cambiar de escena
signal next_level_pressed

func _ready():
	# Pausamos el juego tan pronto aparece esta pantalla
	get_tree().paused = true
	# Nos aseguramos de que este menú (y su botón) funcione mientras el juego está pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/main_menu.tscn")


func _on_next_level_button_pressed() -> void:
	# Quitamos la pausa antes de cambiar de escena
	get_tree().paused = false
	
	# Emitimos la señal para que el script del nivel nos escuche
	next_level_pressed.emit()
	
	# Nos destruimos
	queue_free()
