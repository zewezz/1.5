extends Node

var score = 0
@onready var score_label: Label = $score_label


func add_point():
	score += 1
	print(score)
	score_label.text = "Satisfied Customer: " + str(score) 
