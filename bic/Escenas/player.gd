extends CharacterBody2D

@export var tile_size := 32
@onready var animated_sprite = $AnimatedSprite2D

var last_animation : String = "walk_down"
var score: int = 0
var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false
var move_speed := 100.0

# Guarda la dirección actual de movimiento (si se mantiene presionado)
var move_input: Vector2 = Vector2.ZERO

func _ready():
	target_position = position

func _physics_process(delta):
	if is_moving:
		@warning_ignore("confusable_local_declaration")
		var direction = (target_position - position).normalized()
		velocity = direction * move_speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			is_moving = false
			velocity = Vector2.ZERO
		else:
			if position.distance_to(target_position) < 2:
				position = target_position
				is_moving = false
				velocity = Vector2.ZERO

				if move_input != Vector2.ZERO and not is_moving:
					try_move(move_input)

		return

	# Si no se está moviendo, leemos la tecla (just_pressed para iniciar)
	var direction = Vector2.ZERO
	if Input.is_action_just_pressed("ui_up") or Input.is_action_pressed("ui_up"):
		direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_down") or Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_left") or Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right") or Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT

	if direction != Vector2.ZERO:
		try_move(direction)

func try_move(direction: Vector2) -> void:
	target_position = position + direction * tile_size
	is_moving = true
	move_input = direction

	# Elegir animación
	if direction.y < 0:
		last_animation = "walk_up"
	elif direction.y > 0:
		last_animation = "walk_down"
	elif direction.x < 0:
		last_animation = "walk_left"
	elif direction.x > 0:
		last_animation = "walk_right"

	animated_sprite.play(last_animation)

func _input(event):
	if event.is_action_released("ui_up") or event.is_action_released("ui_down") or \
	   event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		move_input = Vector2.ZERO

func add_points(amount: int) -> void:
	score += amount
	print("Puntos: ", score)
	
	
func game_over() -> void:
	var game_over_screen = get_parent().get_node("GameOverScreen")
	if game_over_screen:
		game_over_screen.show_game_over()
