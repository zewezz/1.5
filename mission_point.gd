extends Node2D
@onready var game_manager: Node = %GameManager
@onready var mis_complete: AudioStreamPlayer2D = $mis_complete

var card_inpoint = false

func play_com():
	mis_complete.play()
	
