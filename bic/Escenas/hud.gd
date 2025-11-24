extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var pause_menu: Control = $PauseMenu
@onready var level_timer: Timer = $LevelTimer
@onready var timer_label: Label = $TimerLabel
var level_score: int = 0

@onready var reloj_atlas: AtlasTexture = $Reloj.texture

var reloj_num_frames: int = 16 # frames del reloj
var reloj_frame_width: int = 18 # ancho
var reloj_frame_height: int = 17 # alto
var reloj_start_x: int = 0 # Posición X del primer frame
var reloj_start_y: int = 1 # Posición Y del primer frame

var reloj_frames: Array[Rect2] = []
var current_reloj_frame: int = 0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		
		# comprobacion
		if get_tree().paused and (not $PauseMenu.visible):
			return 
		
		toggle_pause_menu()
		
		get_viewport().set_input_as_handled()

func toggle_pause_menu():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	
	$LevelTimer.paused = new_pause_state
	$TimerUpdaterLabel.paused = new_pause_state
	
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
	
	# Rellena el array con todas las regiones de los frames del reloj
	for i in range(reloj_num_frames):
		var x = reloj_start_x + (i * reloj_frame_width)
		reloj_frames.append(Rect2(x, reloj_start_y, reloj_frame_width, reloj_frame_height))

func _on_pause_button_pressed():
	if get_tree().paused and (not $PauseMenu.visible):
		return
		
	toggle_pause_menu()

# Esta función se activa con la señal del botón "Reanudar"
func _on_resume_pressed():
	get_tree().paused = false
	$LevelTimer.paused = false
	$TimerUpdaterLabel.paused = false

# Esta función se activa con la señal del botón "Salir al Menú"
func _on_quit_pressed():
	# Siempre reanuda el juego antes de cambiar de escena
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/main_menu.tscn")


func _on_timer_updater_label_timeout() -> void:
	update_timer_display()
	# Avanza al siguiente frame del reloj
	current_reloj_frame = (current_reloj_frame + 1) % reloj_num_frames

	# Actualiza la región del AtlasTexture para mostrar el nuevo frame
	if not reloj_frames.is_empty():
		reloj_atlas.region = reloj_frames[current_reloj_frame]

# Formatea el tiempo restante y lo muestra
func update_timer_display():
	# Obtiene el tiempo restante del timer de 2 minutos
	var time_remaining = level_timer.time_left
	
	# Calcula minutos y segundos
	var minutes = int(time_remaining) / 60
	var seconds = int(time_remaining) % 60
	
	# Formatea el texto como "02:00"
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	
func _on_level_timer_timeout():
	# Busca al jugador en el grupo "player"
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		var player = players[0]

		# Llama a la función de game over que ya tiene el jugador
		if player.has_method("game_over"):
			player.game_over()


func stop_all_timers():
	$LevelTimer.stop()
	$TimerUpdaterLabel.stop()
