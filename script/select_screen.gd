class_name SelectScreen

extends Node2D
@onready var alert: Node2D = $".."

var mission_data: MissionData

# Interface
@export var title_headline: Label
@export var description_headline: Label 
@export var mission_points: Array[Node2D] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_mission()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func _on_alert_open_screen() -> void:
	self.visible = true
	print("signal recieve")

#func _on_return_area(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#self.visible = false
		#print("close sreen")
		
func setup_mission():
	# mission_data cannot be null, initialize anon one
	if mission_data == null:
		mission_data = MissionData.new()
	var count = 0
	# loop for all mission point
	# disable the point that index exceed the requirement number
	for point in mission_points:
		if count > mission_data.requirement_count - 1:
			mission_points[count].disable()
			mission_points[count].visible = false
		count = count + 1
	
	title_headline.text = mission_data.title
	
func set_new_mission(new_mission: MissionData):
	mission_data = new_mission
	setup_mission()
