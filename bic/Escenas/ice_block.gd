extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var break_time := 0.3  # duración total de la animación de romperse

var is_breaking := false

func _ready():
	# Asegura que esté visible y sólido al iniciar
	modulate = Color.WHITE
	is_breaking = false

func break_block():
	if is_breaking:
		return
	is_breaking = true

	# Si hay una animación, la reproduce
	if anim_player and anim_player.has_animation("break"):
		anim_player.play("break")
	else:
		# Si no tienes AnimationPlayer, se desvanece manualmente
		await fade_out()

	queue_free()

func fade_out():
	var steps = 5
	for i in range(steps):
		modulate.a = 1.0 - (i / float(steps))
		await get_tree().create_timer(break_time / steps).timeout
