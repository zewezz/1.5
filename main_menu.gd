extends Node2D

var button_type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fade_transition/AnimationPlayer.play("fade_out")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	button_type = "start"
	$Fade_transition.show()
	$Fade_transition/Fade_Timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")


func _on_option_pressed() -> void:
	button_type = "credit"
	$Fade_transition.show()
	$Fade_transition/Fade_Timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://scene/main.tscn")
	elif button_type == "credit":
		get_tree().change_scene_to_file("res://scene/credit.tscn")
	
