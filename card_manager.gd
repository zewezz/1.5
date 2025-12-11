class_name CardManager
extends Node2D

static var instance: CardManager

@onready var game_manager: Node = %GameManager
@onready var alert_2: Node2D = $"../Alert2"
@onready var alert_3: Node2D = $"../Alert3"

signal back_to_hand_action

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_MISSION = 2
const ANIM_COOLDOWN_NAME = "cooldown"

var card_draging
var screen_size
var is_hoverin_on_card
var center_offset
var player_hand_reference

var card_in_snap: Array = []

# Called when the node enters the scene tree for the first time.

signal back_to_hand

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	player_hand_reference = $"../PlayerHand"
	CardManager.instance = self
	
func _process(delta: float) -> void:
	if card_draging:
		var mouse_pos = get_global_mouse_position()
		card_draging.position = Vector2(clamp(mouse_pos.x, 0,screen_size.x), 	
		clamp(mouse_pos.y, 0, screen_size.y))


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = raycast_checkcard()
			if card:
				start_drag(card)
		else:
			if card_draging:
				finish_drag()
			
func start_drag(card):
	card_draging = card
	card.scale = Vector2(1,1)

func finish_drag():
	
	# FIX: Save the reference and immediately stop dragging!
	var card_to_process = card_draging 
	card_draging = null # <--- Card stops following the cursor NOW
	
	if not is_instance_valid(card_to_process):
		return # Safety check
	card_to_process.scale = Vector2(1.05,1.05)
	var mission_point_found = raycast_checkmission()
	
	if mission_point_found and mission_point_found.is_ready_to_snap():
		player_hand_reference.remove_card_from_hand(card_to_process)
		card_to_process.position = mission_point_found.global_position
		print(card_to_process.position)
		card_to_process.get_node("Area2D/CollisionShape2D").disabled = true
		mission_point_found.card_snap_here()
		# Do not use await
		# var msg = await back_to_hand_action
		# check_card_on_sescreen(msg, card_to_process)
		
		# The function itself returns a signal object because it contains an 'await'.
		#game_manager.add_point()
		card_in_snap.append(card_to_process)
	else:
		player_hand_reference.add_card_to_hand(card_to_process)
	
	
			
func connect_card_signal(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	
func on_hovered_over_card(card):
	if check_is_play_cooldown(card):
		return
	if !is_hoverin_on_card:
		is_hoverin_on_card= true
		highlight_card(card, true)

func on_hovered_off_card(card):
	highlight_card(card, false)
	#check when hover form oneto another card
	var new_card_hovered = raycast_checkcard()
	if new_card_hovered:
		highlight_card(new_card_hovered, true)
	else:
		is_hoverin_on_card = false
	
func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05,1.05)
		card.z_index = 6
	else:
		card.scale = Vector2(1,1)
		card.z_index = 5
		
func raycast_checkmission():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	
	parameters.collision_mask = COLLISION_MASK_MISSION
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		print(result[0].collider)
		return result[0].collider.get_parent()
		
	return null		
		
func raycast_checkcard():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_higher_index(result)
	return null

func get_higher_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func check_is_play_cooldown(card: Node2D):
	var cooldown_bar = card.get_node("TextureProgressBar")
	var anim_player: AnimationPlayer = card.get_node("AnimationPlayer")
	if not is_instance_valid(anim_player) or not is_instance_valid(cooldown_bar):
		# Print an error if nodes are missing and exit the function.
		print("Missing 'AnimationPlayer' or 'TextureProgressBar' child nodes in the card instance.")
		return false
		
	if anim_player.current_animation == ANIM_COOLDOWN_NAME:
		return true
	return false
	
	
# MODIFIED: Takes the specific card instance as an argument.
# This function is now directly awaitable.
func play_cooldown(card: Node2D):
	# Find the necessary nodes relative to the card instance
	var cooldown_bar = card.get_node("TextureProgressBar")
	var anim_player = card.get_node("AnimationPlayer")
	if not is_instance_valid(anim_player) or not is_instance_valid(cooldown_bar):
		# Print an error if nodes are missing and exit the function.
		print("Missing 'AnimationPlayer' or 'TextureProgressBar' child nodes in the card instance.")
		return
	# 1. Turn on the bar
	cooldown_bar.visible = true
	# 2. Play the animation
	anim_player.play("cooldown")
	# 3. Use 'await' to pause the function until the 'animation_finished' signal is emitted.
	var finished_anim_name = await anim_player.animation_finished
	# 4. Check if the animation that finished was the one we were waiting for
	if finished_anim_name == "cooldown":
		# 5. Turn off the bar (This code runs ONLY after the animation is finished)
		cooldown_bar.visible = false
		# Removed: emit_signal("cooldown_finished")
		print("Cooldown finished.")
	else:
		# Optional: Handle if another animation interrupted or finished unexpectedly
		pass

func _on_alert_2_back_to_hand(msg: String) -> void:
	emit_signal("back_to_hand_action", msg)
	#print("BTH" + msg)
	
	pass # Replace with function body.


func _on_alert_3_back_to_hand(msg: String) -> void:
	emit_signal("back_to_hand_action", msg)
	#print("BTH" + msg)
	pass # Replace with function body.

func check_card_on_sescreen(action: String, card)-> void:
	if (action == "sendGhost"):
		emit_signal("back_to_hand_action")
		player_hand_reference.add_card_to_hand(card)
		play_cooldown(card) 
		card.get_node("Area2D/CollisionShape2D").disabled = false
	elif (action == "undo"):
		player_hand_reference.add_card_to_hand(card)
		card.get_node("Area2D/CollisionShape2D").disabled = false
		
func _on_back_to_hand(msg: String):
	for card in card_in_snap:
		check_card_on_sescreen(msg, card)
	card_in_snap.clear()

	
