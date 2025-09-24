extends Area2D

@export var points: int = 10  # puntos que da la fruta

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # Asegúrate de que el Player tenga el grupo "player"
		body.add_points(points)  # Llama a una función del player para sumar puntos
		queue_free()  # Se elimina la fruta
