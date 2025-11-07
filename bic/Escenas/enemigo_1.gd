extends CharacterBody2D

@export var tile_size: int = 32
@export var move_speed: float = 25.0
@export var initial_direction: Vector2 = Vector2.RIGHT
var is_trapped: bool = false
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2
var target_position: Vector2
var is_moving: bool = false

func _ready() -> void:
	direction = initial_direction.normalized()
	target_position = position
	$Hitbox.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	# Si está atrapado, no hace nada.
	if is_trapped:
		_set_next_target()
		return
	
	if is_moving:
		var step = (target_position - position).normalized() * move_speed * delta
		var collision = move_and_collide(step)

		if collision:
			# Si hay colisión, rotamos
			_rotate_direction()
			_set_next_target()
			return

		if position.distance_to(target_position) <= step.length():
			position = target_position
			is_moving = false
			_set_next_target()
		else:
			position += step
	else:
		_set_next_target()

	_update_animation()


func _set_next_target() -> void:
	# Redondea la posición actual a la cuadrícula más cercana
	var snapped_pos = position.round()

	# Calcula la siguiente posición desde la posición "limpia", no la decimal
	var try_pos = snapped_pos + direction * tile_size

	# La "mirada" también debe usar la posición limpia
	var collision = move_and_collide((try_pos - snapped_pos).normalized() * 2) 

	# (El resto de la función sigue igual)
	if collision:
		# Si no puede avanzar, gira
		var tries := 0
		while tries < 4 and collision:
			_rotate_direction()
			try_pos = snapped_pos + direction * tile_size # <--- CAMBIA ESTO (usa snapped_pos)
			collision = move_and_collide((try_pos - snapped_pos).normalized() * 2) # <--- CAMBIA ESTO (usa snapped_pos)
			tries += 1
		if tries >= 4:
			if not is_trapped: # Para que solo lo imprima una vez
				print("¡Enemigo atascado!")
			is_trapped = true
			is_moving = false
			
			direction = Vector2.DOWN
			_update_animation()
			anim.stop()
			
			return
			
	# Si llegamos aquí, es porque hay un camino libre
	
	if is_trapped:
		print("¡Enemigo libre!")
	
	is_trapped = false # Ya no esta encerrado
	target_position = try_pos
	is_moving = true


func _rotate_direction() -> void:
	# Gira 90° a la derecha
	direction = Vector2(-direction.y, direction.x).normalized()


func _update_animation() -> void:
	# Estos números (-4, 4, 0) son ejemplos.
	# ¡Tendrás que ajustarlos hasta que el sprite se vea centrado!
	
	if direction.dot(Vector2.RIGHT) > 0.9:
		anim.play("walk_right")
		anim.position.x = 4  # Mueve el sprite 4 píxeles a la DERECHA
		
	elif direction.dot(Vector2.LEFT) > 0.9:
		anim.play("walk_left")
		anim.position.x = -4 # Mueve el sprite 4 píxeles a la IZQUIERDA
		
	elif direction.dot(Vector2.DOWN) > 0.9:
		anim.play("walk_down")
		anim.position.x = 0  # Centra el sprite
		
	elif direction.dot(Vector2.UP) > 0.9:
		anim.play("walk_up")
		anim.position.x = 0  # Centra el sprite


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.game_over()
