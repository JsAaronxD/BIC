extends Node2D

var banana_count: int = 0

func _ready():
    await get_tree().process_frame
    
    # contamos las bananas
    banana_count = get_tree().get_nodes_in_group("fruit").size()

    # conectamos la señal a las bananas
    for banana in get_tree().get_nodes_in_group("fruit"):
        banana.banana_eaten.connect(_on_banana_eaten)

    # apagamos la segunda fruta
    for fruit in get_tree().get_nodes_in_group("second_fruit"):
        fruit.hide() # Oculta el sprite
        
        # Desactiva la habilidad de la fruta de tener colision
        fruit.monitoring = false 
        

func _on_banana_eaten():
    banana_count -= 1
    
    if banana_count <= 0:
        _show_second_fruits()

func _show_second_fruits():
    # comprobar si funciona en la consola
    print("Mostrando uvas")
    
    for fruit in get_tree().get_nodes_in_group("second_fruit"):
        fruit.show() # Muestra el sprite
        
        # Reactiva la habilidad de la fruta de tener colision
        fruit.monitoring = true
