extends Node2D

var random_value = 4

@onready var popup: Window = $Window
@onready var dice_roll: AnimatedSprite2D = $Window/Dice_roll

func dicey():
	randomize()
	random_value = randi_range(1, 6)
	print(random_value)

func _on_window_close_request():
	popup.hide()
	
func _input(event):
	
	if event.is_action_pressed("Roll"):
		popup.show()
		dicey()
		
func _process(delta):
	match random_value:
		1:
			dice_roll.play("1")
		2:
			dice_roll.play("2")
		3:
			dice_roll.play("3")
		4:
			dice_roll.play("4")
	
	
	
