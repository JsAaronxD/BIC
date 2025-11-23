extends Control

@export var game_scene: PackedScene
@onready var options_menu = $OptionsMenu

func _on_play_pressed():
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)

func _on_exit_pressed():
	get_tree().quit()

func _on_opciones_pressed() -> void:
	options_menu.show()
