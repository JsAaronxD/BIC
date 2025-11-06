extends Node

var total_score: int = 0

# Esta función la usará el HUD para sumar puntos
func add_to_total_score(amount: int):
	total_score += amount
	print("Score Global ahora es: ", total_score)

# Esta función la usará el Menú Principal
func reset_total_score():
	total_score = 0
