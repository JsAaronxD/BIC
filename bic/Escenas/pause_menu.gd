extends Control

# Señales que el HUD escuchará
signal resume_pressed
signal quit_pressed

func _ready():
	# Conecta los botones a este script
	$VBoxContainer/ResumeButton.pressed.connect(_on_resume_button_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(_on_options_button_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_button_pressed)

func _on_resume_button_pressed():
	hide() # Oculta el menú de pausa
	resume_pressed.emit() # Avisa al HUD que reanude

func _on_options_button_pressed():
	print("Menu de opciones presionado (TODO)")
	# Aquí podrías mostrar/ocultar otro panel de opciones

func _on_quit_button_pressed():
	quit_pressed.emit() # Avisa al HUD que salga al menú
