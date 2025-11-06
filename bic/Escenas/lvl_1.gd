extends Node2D

var banana_count: int = 0

func _ready():
	# Espera un frame para asegurarse de que todas las bananas
	# hayan ejecutado su _ready() y se hayan añadido al grupo "fruit".
	await get_tree().process_frame
	
	# 1. Ahora SÍ contará bien las bananas
	banana_count = get_tree().get_nodes_in_group("fruit").size()
	
	# (Opcional: para ver si funciona)
	print("Nivel iniciado. Bananas a encontrar: ", banana_count)

	# 2. Conecta la señal de cada banana
	for banana in get_tree().get_nodes_in_group("fruit"):
		banana.banana_eaten.connect(_on_banana_eaten)

	# 3. Arreglo "Fruta Fantasma":
	# Apaga TODA la fruta especial (sprite Y colisión)
	for fruit in get_tree().get_nodes_in_group("second_fruit"):
		fruit.hide() # Oculta el sprite
		
		# Busca el nodo de colisión y lo deshabilita
		if fruit.has_node("CollisionShape2D"):
			fruit.get_node("CollisionShape2D").disabled = true
		

func _on_banana_eaten():
	banana_count -= 1
	
	# (Opcional: para ver si funciona)
	print("¡Banana comida! Quedan: ", banana_count)
	
	if banana_count <= 0:
		_show_second_fruits()

func _show_second_fruits():
	# (Opcional: para ver si funciona)
	print("¡Todas las bananas comidas! Mostrando frutas especiales.")
	
	for fruit in get_tree().get_nodes_in_group("second_fruit"):
		fruit.show() # Muestra el sprite
		
		# Vuelve a HABILITAR la colisión
		if fruit.has_node("CollisionShape2D"):
			fruit.get_node("CollisionShape2D").disabled = false
