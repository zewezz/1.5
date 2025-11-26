extends Node2D
@onready var game_manager: Node = %GameManager
@onready var mis_complete: AudioStreamPlayer2D = $mis_complete

@onready var select_screen: Node2D = $".."

var is_enable = true

# You can try this
# enum state {DISABLE, HAS_CARD, EMPTY}

var card_inpoint = false # Is that card here

func play_com():
	
	mis_complete.play()
	

func card_snap_here():
	card_inpoint = true
	
func on_mission_completed():
	card_inpoint = false

func is_empty():
	return not card_inpoint
	
func is_ready_to_snap():
	return is_empty() and is_enable
	
func disable():
	is_enable = false
