extends CharacterBody2D

@export var speed = 150  # Velocidad del personaje
@onready var animated_sprite = $AnimatedSprite2D

# Guardamos la última animación usada
var last_animation : String = "walk_down"

func _physics_process(delta):
	var direction = Vector2.ZERO
	var is_moving = false

	# Movimiento vertical tiene prioridad
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
		is_moving = true
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
		is_moving = true
	# Solo si no hay movimiento vertical, chequea horizontal
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		is_moving = true
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1
		is_moving = true

	if is_moving:
		velocity = direction * speed

		# Decide animación según dirección y la guarda como última
		if direction.y < 0:
			last_animation = "walk_up"
		elif direction.y > 0:
			last_animation = "walk_down"
		elif direction.x < 0:
			last_animation = "walk_left"
		elif direction.x > 0:
			last_animation = "walk_right"

		animated_sprite.play(last_animation)
	else:
		velocity = Vector2.ZERO
		# Reproduce la última animación, pero se queda en el primer frame (quieto)
		animated_sprite.play(last_animation)
		animated_sprite.stop()

	move_and_slide()
