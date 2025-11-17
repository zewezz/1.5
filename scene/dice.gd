extends Node2D

var random_value = 4

@onready var popup: Window = $Window
@onready var dice_roll: AnimatedSprite2D = $Window/Dice_roll


func _ready():
	randomize()
	popup.hide()

func set_dice_result():
	random_value = randi_range(1, 4)
	print("Final Dice Roll: ", random_value)
	dice_roll.play(str(random_value))

func _on_window_close_request():
	popup.hide()
	
func _input(event):
	#the input key is "k"
	if event.is_action_pressed("Roll") and not dice_roll.is_playing():
		popup.show()
		dice_roll.play("wait_dice")
		await get_tree().create_timer(1.0).timeout
		set_dice_result()
		await get_tree().create_timer(1.0).timeout
		popup.hide()
