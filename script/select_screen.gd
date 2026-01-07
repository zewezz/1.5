class_name SelectScreen

extends Node2D
@onready var alert: Node2D = $".."

var mission_data: MissionData

# Interface
@export var title_headline: Label
@export var description_headline: Label 
@export var mission_points: Array[Node2D]

@export var screen_position: Vector2 = Vector2(990, 580)
signal card_return_hand 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# setup_mission()
	setup_return_hand_signal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func _on_alert_open_screen() -> void:
	print("signal recieve")
	if  GameManager.get_select_screen_open() == false:
		self.visible = true
		GameManager.set_select_screen_open(true)
		
func _input(event):
	if event.is_action_pressed("close_screen") and GameManager.get_select_screen_open() and self.visible == true:
		self.visible = false
		GameManager.set_select_screen_open(false)
		emit_signal("card_return_hand","undo")

#func _on_return_area(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#self.visible = false
		#print("close sreen")
		
func setup_mission():
	print("Setup Mission")
	# mission_data cannot be null, initialize anon one
	if mission_data == null:
		mission_data = MissionData.new()

	#print setuped mission  
	print("Title: %s" % [mission_data.title])
	print("Requirement Count: %s" % [mission_data.requirement_count])

	# loop for all mission point
	# disable the point that index exceed the requirement number
	var count = 0
	for point in mission_points:
		if count > mission_data.requirement_count - 1:
			mission_points[count].disable()
			mission_points[count].visible = false
		count = count + 1
	
	title_headline.text = mission_data.title
	description_headline.text = mission_data.description
	
func set_new_mission(new_mission: MissionData):
	mission_data = new_mission
	setup_mission()

func _on_button_pressed() -> void:
	emit_signal("card_return_hand","sendGhost")
	GameManager.set_select_screen_open(false)
	self.visible = false

func setup_position():
	self.global_position = screen_position
	
func setup_return_hand_signal():
	var card_manager: CardManager = CardManager.instance
	if card_manager != null:
		connect("card_return_hand", card_manager._on_back_to_hand)
	else:
		print("Error: Cannot find card_manager singleton") 
	
