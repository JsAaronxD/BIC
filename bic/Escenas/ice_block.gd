extends StaticBody2D

@onready var body_sprite: Sprite2D = $BodySprite
@onready var top_sprite: Sprite2D = $TopSprite

@export var tile_size: int = 32
var is_breaking: bool = false

func _ready():
	# asegura pertenecer al grupo para detectarlo desde queries
	add_to_group("ice_block")
	update_visibility()

# Public: rompe el bloque (llamado por el jugador)
func break_block():
	if is_breaking:
		return
	is_breaking = true
	# opcional: efecto visual/sonido antes de destruir
	await get_tree().create_timer(0.08).timeout
	# antes de borrarlo, notifica al bloque que esté debajo para que actualice
	_notify_block_below_of_change()
	queue_free()

# Actualiza visibilidad de las partes segun bloques vecinos
func update_visibility():
	# si faltan sprites, evitamos errores
	if not body_sprite:
		return

	# ¿hay bloque justo ENCIMA?
	var above = _get_block_at(global_position + Vector2(0, -tile_size))
	# ¿hay bloque justo DEBAJO?
	var below = _get_block_at(global_position + Vector2(0, tile_size))

	# REGLA pedida: cuando haya un bloque encima, **ocultamos la parte de abajo** (body)
	# (si NO hay bloque encima, mostramos la parte de abajo)
	body_sprite.visible = not (above != null)

	# TopSprite (brillo): normalmente se muestra si NO hay bloque encima (top-most)
	if top_sprite:
		top_sprite.visible = (above == null)

	# Opcional: si un bloque está debajo y queremos ajustar su visibilidad ahora:
	# if below:
	#     below.update_visibility()

# NOTIFICACIONES para que vecinos se actualicen al crear/romper
func _notify_neighbors_of_change():
	# actualiza el bloque encima y el debajo si existen
	var above = _get_block_at(global_position + Vector2(0, -tile_size))
	if above:
		above.update_visibility()
	var below = _get_block_at(global_position + Vector2(0, tile_size))
	if below:
		below.update_visibility()

func _notify_block_below_of_change():
	var below = _get_block_at(global_position + Vector2(0, tile_size))
	if below:
		below.update_visibility()

# Helper: devuelve el nodo bloque en una posición de grid (o null)
func _get_block_at(world_pos: Vector2) -> StaticBody2D:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = world_pos
	params.collide_with_bodies = true
	params.collide_with_areas = false
	# realiza la query
	var hits := space_state.intersect_point(params)
	for hit in hits:
		var collider = hit.get("collider")
		if collider and collider.is_in_group("ice_block"):
			return collider
	return null
