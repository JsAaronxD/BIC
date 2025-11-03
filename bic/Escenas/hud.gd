extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var pause_menu: Control = $PauseMenu

func _process(delta):
	# Comprueba el estado global de Input, es más seguro
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause_menu()

func toggle_pause_menu():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	
	if new_pause_state:
		pause_menu.show()
	else:
		pause_menu.hide()
		
func _on_player_score_updated(new_score: Variant) -> void:
	score_label.text = "Score: %s" % new_score

func _ready():
	# Conecta las señales del PauseMenu a este script del HUD
	pause_menu.resume_pressed.connect(_on_resume_pressed)
	pause_menu.quit_pressed.connect(_on_quit_pressed)
	
	# Asegúrate de que el menú de pausa esté oculto al empezar
	pause_menu.hide()

func _on_pause_button_pressed():
	toggle_pause_menu()

# Esta función se activa con la señal del botón "Reanudar"
func _on_resume_pressed():
	get_tree().paused = false
	# El menú ya se ocultó a sí mismo

# Esta función se activa con la señal del botón "Salir al Menú"
func _on_quit_pressed():
	# Siempre reanuda el juego antes de cambiar de escena
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/main_menu.tscn")
