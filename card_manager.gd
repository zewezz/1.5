extends Node2D


const COLLISION_MASK_CARD = 1
const COLLISION_MASK_MISSION = 2

var card_draging
var screen_size
var is_hoverin_on_card
var center_offset
var player_hand_reference
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	
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
	card.scale = Vector2(1.,1)

func finish_drag():
	
	card_draging.scale = Vector2(1.05,1.05)
	var mission_point_found = raycast_checkmission()
	#var collision_shape_node = mission_point_found.get_node("Area2D/CollisionShape2D")
	if mission_point_found and not mission_point_found.card_inpoint:
		player_hand_reference.remove_card_from_hand(card_draging)
		card_draging.position = mission_point_found.position
		card_draging.get_node("Area2D/CollisionShape2D").disabled = true
		mission_point_found.card_inpoint =true
		play_cooldown(card_draging)
		
	else:
		player_hand_reference.add_card_to_hand(card_draging)
	card_draging = null
	
			
func connect_card_signal(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	
func on_hovered_over_card(card):
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
		card.z_index = 2
	else:
		card.scale = Vector2(1,1)
		card.z_index = 1
		
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
	
# MODIFIED: Takes the specific card instance as an argument.
func play_cooldown(card: Node2D):
	# Assuming TextureProgressBar is a direct child of the card
	var cooldown_bar = card.get_node("TextureProgressBar")
	# Assuming AnimationPlayer is a direct child of the card
	var anim_player = card.get_node("AnimationPlayer")
	
	if is_instance_valid(cooldown_bar):
		cooldown_bar.visible = true
		
	if is_instance_valid(anim_player):
		anim_player.play("cooldown")
		
		# Connect the signal to the dedicated cleanup function.
		# .bind(cooldown_bar) ensures we pass the specific TextureProgressBar instance.
		# CONNECT_ONE_SHOT ensures the connection is automatically removed after the first call.
		anim_player.animation_finished.connect(_on_cooldown_finished_for_bar.bind(cooldown_bar), CONNECT_ONE_SHOT)

# NEW FUNCTION: Handles the cleanup for a specific bar instance.
func _on_cooldown_finished_for_bar(bar: TextureProgressBar, anim_name: StringName):
	# Check if the finished animation was the cooldown
	if anim_name == "cooldown":
		if is_instance_valid(bar):
			bar.visible = false
