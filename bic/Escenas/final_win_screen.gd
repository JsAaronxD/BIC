extends CanvasLayer

@onready var win_music: AudioStreamPlayer = $win_music
@onready var score_label = $VBoxContainer/ScoreLabel
# Esta señal le avisará al nivel que debe cambiar de escena
signal next_level_pressed

func _ready():
	# Pausamos el juego tan pronto aparece esta pantalla
	get_tree().paused = true
	# Nos aseguramos de que este menú (y su botón) funcione mientras el juego está pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	win_music.play()
	
	if score_label:
		score_label.text = "PUNTAJE FINAL: " + str(GameManager.total_score)
	
func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	GameManager.reset_total_score()
	get_tree().change_scene_to_file("res://Escenas/main_menu.tscn")
