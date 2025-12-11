extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fade_transition/AnimationPlayer.play("fade_out")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$Fade_transition.show()
	$Fade_transition/Fade_Timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
	pass # Replace with function body.
