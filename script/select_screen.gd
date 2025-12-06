extends Node2D
@onready var alert: Node2D = $".."
@export var requirement_count:int = 3
@export var mission_points: Array[Node2D] 
@onready var game_manager: Node = %GameManager
@onready var player_screen:Vector2 = get_viewport_rect().size/2

signal card_return_hand





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set select_screen position to the middle of the screen
	self.global_position = player_screen
	 # Replace with function body.
	var count = 0
	# loop for all mission point
	# disable the point that index exceed the requirement number
	for point in mission_points:
		if count > requirement_count - 1:
			mission_points[count].disable()
			mission_points[count].visible = false
		count = count + 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	#print(game_manager.get_select_screen_open())
	pass


func _on_alert_open_screen() -> void:
	if  game_manager.get_select_screen_open() == false:
		
		self.visible = true
		game_manager.set_select_screen_open(true)
		
func _on_alert_2_open_screen() -> void:
	_on_alert_open_screen()
	pass # Replace with function body.


func _on_alert_3_open_screen() -> void:
	_on_alert_open_screen()
	pass # Replace with function body.	

func _input(event):
	if event.is_action_pressed("close_screen") and game_manager.get_select_screen_open() and self.visible == true:
		self.visible = false
		game_manager.set_select_screen_open(false)
		emit_signal("card_return_hand","undo")
		

#func _on_return_area(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#self.visible = false
		#print("close sreen")

func _on_button_pressed() -> void:
	emit_signal("card_return_hand","sendGhost")
	game_manager.set_select_screen_open(false)
	self.visible = false
	pass # Replace with function body.

	
