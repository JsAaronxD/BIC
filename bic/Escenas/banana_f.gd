extends Area2D

@export var points: int = 10
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.add_points(points)
		_play_sound()
		queue_free()

func _play_sound():
	var sfx = AudioStreamPlayer2D.new()
	sfx.stream = sound.stream
	sfx.position = global_position
	get_parent().add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)
