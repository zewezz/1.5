extends Node2D
@onready var alert: Node2D = $".."

@export var requirement_count:int = 3
@export var mission_points: Array[Node2D] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	pass


func _on_alert_open_screen() -> void:
	self.visible = true
	print("signal recieve")

#func _on_return_area(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#self.visible = false
		#print("close sreen")
		
