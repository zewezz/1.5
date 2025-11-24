extends Node2D

const HAND_COUNT = 6
const CARD_SCENE_PATH = "res://scene/card.tscn"
const  CARD_WIDTH = 200
const HAND_Y_POS = 890

var player_hand = []
var center_screen_x
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x/2
	print(center_screen_x)
	var card_scene= preload(CARD_SCENE_PATH)
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		$"../cardManager".add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)
		
func add_card_to_hand(card):
	#print("add_card_to_hand")
	if card not in player_hand:		
		player_hand.insert(0, card)
		update_hand_position()
	else: 
		animate_card_to_pos(card,card.inhand_pos)
		
	
func update_hand_position():
	#print("update_hand_position")
	for i in range(player_hand.size()):
		# Get new card pos based on index pssed in
		var new_position = Vector2(cal_card_pos(i), HAND_Y_POS)
		var card = player_hand[i]
		card.inhand_pos = new_position
		animate_card_to_pos(card, new_position)
		
func cal_card_pos(index):
	#print("cal_card_pos")
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width/2
	return x_offset
	
func animate_card_to_pos(card, new_position):
	#print("animate_card_to_pos")
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position,  0.1)
	
func remove_card_from_hand(card):
	#print("remove_card_from_hand")
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position()
		
func return_card_to_hand(card):
	
	#print("cooldown_finished")
	add_card_to_hand(card)
		
	
