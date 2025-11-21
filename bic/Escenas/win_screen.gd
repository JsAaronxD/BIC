extends CanvasLayer

@onready var win_music: AudioStreamPlayer = $win_music

# señal que le avisara al nivel que debe cambiar de escena
signal next_level_pressed

func _ready():
	# pausamos el juego cuando aparece este menu
	get_tree().paused = true
	# aseguramos que este menu funcione mientras el juego está pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	win_music.play()
	
func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/main_menu.tscn")


func _on_next_level_button_pressed() -> void:
	# quitamos la pausa antes de cambiar de escena
	get_tree().paused = false
	
	# se emite la señal de siguiente nivel
	next_level_pressed.emit()
	
	# se borra
	queue_free()
