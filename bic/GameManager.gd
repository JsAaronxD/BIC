extends Node

var total_score: int = 0
var score_at_level_start: int = 0

func add_to_total_score(amount: int):
	total_score += amount
	print("Score Global ahora es: ", total_score)

func reset_total_score():
	total_score = 0

func save_score_checkpoint():
	score_at_level_start = total_score

func reset_score_to_checkpoint():
	total_score = score_at_level_start
