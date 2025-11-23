extends Area2D

signal banana_eaten

@export var points: int = 50
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("fruit")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.add_points(points)
		_play_sound()
		banana_eaten.emit()
		queue_free()

func _play_sound():
	var sfx = AudioStreamPlayer2D.new()
	sfx.stream = sound.stream
	sfx.position = global_position
	sfx.bus = "SFX"
	get_parent().add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)
	
# Esta función controlará el color.
func set_on_ice(is_on_ice: bool):
	if is_on_ice:
		# Color azul oscuro
		sprite.modulate = Color(0.2, 0.3, 0.8)
	else:
		# Color normal (blanco)
		sprite.modulate = Color(1.0, 1.0, 1.0)
