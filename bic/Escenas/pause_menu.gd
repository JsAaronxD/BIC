extends Control

signal resume_pressed
signal quit_pressed

@onready var options_menu = $OptionsMenu

func _ready():
	# Conecta los botones a este script
	$VBoxContainer/ResumeButton.pressed.connect(_on_resume_button_pressed)
	$VBoxContainer/RetryButton.pressed.connect(_on_retry_button_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_button_pressed)

func _on_resume_button_pressed():
	hide() # Oculta el menú de pausa
	resume_pressed.emit() # Avisa al HUD 

func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	quit_pressed.emit() # Avisa al HUD que salga al menú
	
func _on_options_button_pressed():
	options_menu.show()
