extends Control

@export var game_scene: PackedScene

func _on_play_pressed():
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)

func _on_options_pressed():
	print("Abrir menú de opciones")

func _on_exit_pressed():
	get_tree().quit()
