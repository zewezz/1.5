extends Node

signal play_score
@onready var select_screen_open:bool = false
var score = 0
@onready var score_label: Label = $score_label
@onready var mission_point: Node2D = $"../missionPoint"

func _ready() -> void:
	$Fade_transition/AnimationPlayer.play("fade_out")
	
func add_point():
	score += 1
	print(score)
	score_label.text = "Satisfied Customer: " + str(score) 
	emit_signal("play_score")

func get_select_screen_open()-> bool:
	return select_screen_open
	
	
func set_select_screen_open(val:bool) -> void:
	select_screen_open = val
	
