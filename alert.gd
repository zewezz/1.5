class_name Alert
extends Node2D
signal open_screen
signal back_to_hand
@onready var button: Button = $Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed() -> void:
	emit_signal("open_screen")
	
func _on_select_screen_card_return_hand(msg: String) -> void:
	print("BACK TO HAND COMPLTE"+msg)
	emit_signal("back_to_hand", msg)
	if msg == "sendGhost":
		play_cooldown(button)

func play_cooldown(alertpoint: Button):
	# Find the necessary nodes relative to the card instance
	var cooldown_bar = alertpoint.get_node("TextureProgressBar")
	var anim_player = alertpoint.get_node("AnimationPlayer")
	if not is_instance_valid(anim_player) or not is_instance_valid(cooldown_bar):
		# Print an error if nodes are missing and exit the function.
		print("Missing 'AnimationPlayer' or 'TextureProgressBar' child nodes in the card instance.")
		return
	# 1. Turn on the bar
	cooldown_bar.visible = true
	# 2. Play the animation
	anim_player.play("cooldown")
	# 3. Use 'await' to pause the function until the 'animation_finished' signal is emitted.
	await anim_player.animation_finished
	cooldown_bar.visible = false
	print("Cooldown finished.")
	# Destroy self
	queue_free()
