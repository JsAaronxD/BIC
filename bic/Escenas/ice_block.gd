extends StaticBody2D

@onready var body_sprite: Sprite2D = $Sprite2D
@onready var top_sprite: Sprite2D = $TopSprite
# Referencia al nuevo nodo de animación
@onready var anim_player: AnimatedSprite2D = $AnimatedSprite2D 

@export var tile_size: int = 32
var is_breaking: bool = false

func _ready():
	add_to_group("ice_block")
	# Asegurarse que la animación esté oculta al inicio por si acaso
	if anim_player:
		anim_player.visible = false
	update_visibility()

func break_block():
	if is_breaking:
		return
	is_breaking = true
	
	# Desactivar colision
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Ocultar sprites estaticos
	if body_sprite: body_sprite.visible = false
	if top_sprite: top_sprite.visible = false
	
	# mostrar animacion de ruptura
	if anim_player:
		anim_player.visible = true
		anim_player.play("break")
		
		# esperar que termine la animacion
		await anim_player.animation_finished
	
	# notificar y borrar el bloque
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
