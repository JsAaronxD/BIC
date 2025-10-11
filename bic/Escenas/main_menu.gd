extends Control

# Cambia esto por la ruta a tu escena principal del juego
@export var game_scene: PackedScene

func _on_play_pressed():
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)

func _on_options_pressed():
	print("Abrir menú de opciones")
	# Aquí puedes mostrar un Popup o cambiar de escena de Opciones

func _on_exit_pressed():
	get_tree().quit()
