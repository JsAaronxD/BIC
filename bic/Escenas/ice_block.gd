extends StaticBody2D

@onready var body_sprite: Sprite2D = $Sprite2D
@onready var top_sprite: Sprite2D = $TopSprite

@export var tile_size: int = 32
var is_breaking: bool = false

func _ready():
	# asegura pertenecer al grupo para detectarlo desde queries
	add_to_group("ice_block")
	update_visibility()

# funcion para romper el blque
func break_block():
	if is_breaking:
		return
	is_breaking = true
	# opcional: efecto visual/sonido antes de destruir
	await get_tree().create_timer(0.08).timeout
	# antes de borrarlo, notifica al bloque que esté debajo para que actualice
	_notify_block_below_of_change()
	queue_free()

# actualiza como se vera el bloque
func update_visibility():
	# si faltan sprites se intenta evitar errores
	if body_sprite:
		return

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


func _get_block_at(world_pos: Vector2) -> StaticBody2D:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = world_pos
	params.collide_with_bodies = true
	params.collide_with_areas = false

	var hits := space_state.intersect_point(params)
	for hit in hits:
		var collider = hit.get("collider")
		if collider and collider.is_in_group("ice_block"):
			return collider
	return null
