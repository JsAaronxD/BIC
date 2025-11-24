extends CharacterBody2D

signal score_updated(new_score)
@export var tile_size := 32
@export var ice_block_scene: PackedScene
@export var block_delay := 0.1
@export var hud: CanvasLayer

@onready var animated_sprite = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer = $SFX_Player
@onready var sfx_player2: AudioStreamPlayer = $SFX_Player2

var sound_break = preload("res://sounds/sfx_breakIce.wav")
var sound_break2 = preload("res://sounds/sfx_breakIce2.wav")
var sound_place = preload("res://sounds/sfx_placeIce.wav")

var last_animation : String = "walk_down"
var score: int = 0
var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false
var move_speed := 100.0
var placing_blocks := false

# dirección actual de movimiento
var move_input: Vector2 = Vector2.ZERO
# dirección a la que mira el personaje
var look_direction: Vector2 = Vector2.DOWN

func _ready():
	target_position = position

func _physics_process(delta):
	if is_moving:
		@warning_ignore("confusable_local_declaration")
		var direction = (target_position - position).normalized()
		velocity = direction * move_speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider and collider.is_in_group("enemy"):
				game_over()

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

	# leemos la tecla
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
		
	if Input.is_action_just_pressed("ui_accept") and not placing_blocks:
		place_or_break_blocks()

func try_move(direction: Vector2) -> void:
	target_position = position + direction * tile_size
	is_moving = true
	move_input = direction

	# animación
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
	score_updated.emit(score)
	
func game_over() -> void:
	var game_over_screen = get_parent().get_node("GameOverScreen")
	if game_over_screen:
		game_over_screen.show_game_over()
		
	if hud and hud.has_method("stop_all_timers"):
		hud.stop_all_timers()

	# genera los bloques uno por uno
func place_or_break_blocks() -> void:
	if not ice_block_scene or placing_blocks:
		return
	placing_blocks = true

	var dir = Vector2.ZERO
	match last_animation:
		"walk_up": dir = Vector2.UP
		"walk_down": dir = Vector2.DOWN
		"walk_left": dir = Vector2.LEFT
		"walk_right": dir = Vector2.RIGHT

	var start_pos = global_position + dir * tile_size
	var space_state := get_world_2d().direct_space_state

	var params := PhysicsPointQueryParameters2D.new()
	params.position = start_pos
	params.collide_with_bodies = true
	params.collide_with_areas = false

	var initial_hits := space_state.intersect_point(params)

	if initial_hits.size() > 0:
		# si hay bloque, romper la fila
		break_ice_line(dir)
	else:
		# si no hay bloque, coloca la fila
		await build_ice_line(dir)

	placing_blocks = false

func build_ice_line(dir: Vector2) -> void:
	var snapped_pos = global_position.round()
	var pos = snapped_pos + dir * tile_size
	
	var space_state := get_world_2d().direct_space_state
	var created_blocks: Array = []

	sfx_player.stream = sound_place
	sfx_player.play()

	await get_tree().process_frame

	while true:
		var params := PhysicsPointQueryParameters2D.new()
		params.position = pos
		params.collide_with_bodies = true
		params.collide_with_areas = false

		var result := space_state.intersect_point(params)

		var hit_existing_block := false
		for hit in result:
			var collider = hit.get("collider")
			if collider and not created_blocks.has(collider):
				hit_existing_block = true
				break

		if hit_existing_block:
			break
		
		# colocar la fruta cuando esta debajo de un bloque de hielo
		var fruit = _get_fruit_at(pos + Vector2(0, -16))
		if fruit and fruit.has_method("set_on_ice"):
			fruit.set_on_ice(true)
			
		var block = ice_block_scene.instantiate()
		block.global_position = pos
		get_parent().add_child(block)
		created_blocks.append(block)
		
		await get_tree().create_timer(block_delay).timeout
		pos += dir * tile_size

func break_ice_line(dir: Vector2) -> void:
	var snapped_pos = global_position.round()
	var pos = snapped_pos + dir * tile_size
	
	var space_state := get_world_2d().direct_space_state

	sfx_player.stream = sound_break
	sfx_player.play()
	
	sfx_player2.stream = sound_break2
	sfx_player2.play()

	while true:
		var params := PhysicsPointQueryParameters2D.new()
		params.position = pos
		params.collide_with_bodies = true
		params.collide_with_areas = false
		
		var result := space_state.intersect_point(params)

		if result.is_empty():
			break

		var hit_block := false
		for hit in result:
			var collider = hit.get("collider")
			if collider and collider.has_method("break_block"):
				
				var fruit = _get_fruit_at(pos + Vector2(0, -16))
				if fruit and fruit.has_method("set_on_ice"):
					fruit.set_on_ice(false)
				
				collider.break_block()
				hit_block = true
				
				break

		if not hit_block:
			break 

		await get_tree().create_timer(block_delay).timeout
		pos += dir * tile_size

func _get_fruit_at(world_pos: Vector2) -> Area2D:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = world_pos
	params.collide_with_bodies = false
	params.collide_with_areas = true
	
	var hits := space_state.intersect_point(params)
	for hit in hits:
		var collider = hit.get("collider")
		if collider and (collider.is_in_group("fruit") or collider.is_in_group("second_fruit")):
			return collider
	return null
