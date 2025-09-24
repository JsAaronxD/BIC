extends CharacterBody2D

@export var speed: float = 80.0
@export var initial_direction: Vector2 = Vector2.RIGHT

var direction: Vector2
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	direction = initial_direction.normalized()

func _physics_process(delta: float) -> void:
	# Intentamos mover en la dirección actual
	var motion = direction * speed * delta
	var col = move_and_collide(motion)

	if col:
		# Girar 90° a la derecha: en Godot (y positivo hacia abajo) la fórmula correcta es (-y, x)
		direction = Vector2(-direction.y, direction.x).normalized()

		# Intentar dar un pequeño paso en la nueva dirección.
		# Si sigue chocando, giramos otra vez (máx 3 giros extra) hasta encontrar espacio libre.
		var tries := 0
		var moved := false
		while tries < 4 and not moved:
			var try_motion = direction * speed * delta
			var c2 = move_and_collide(try_motion)
			if c2:
				direction = Vector2(-direction.y, direction.x).normalized()
				tries += 1
			else:
				moved = true

		# Si después de los giros sigue sin poder moverse, quedará quieto hasta el siguiente frame.
	# Actualizamos la animación según la dirección actual
	_update_animation()

func _update_animation() -> void:
	# Comprueba la dirección aproximada y reproduce la animación correspondiente
	if direction.dot(Vector2.RIGHT) > 0.9:
		anim.play("walk_right")
	elif direction.dot(Vector2.LEFT) > 0.9:
		anim.play("walk_left")
	elif direction.dot(Vector2.DOWN) > 0.9:
		anim.play("walk_down")
	elif direction.dot(Vector2.UP) > 0.9:
		anim.play("walk_up")
