extends CanvasLayer

@onready var music_slider = $VBoxContainer/MusicSlider
@onready var sfx_slider = $VBoxContainer/SFXSlider

func _ready():
	# Conecta las señales de los sliders y el botón
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	$BackButton.pressed.connect(_on_back_button_pressed)
	
	# (Opcional) Pon los sliders en la posición correcta actual
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func _on_music_slider_value_changed(value):
	# Busca el índice del bus "Music"
	var bus_index = AudioServer.get_bus_index("Music")
	# Convierte el valor lineal (0 a 1) a Decibelios y lo aplica
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_back_button_pressed():
	hide()
