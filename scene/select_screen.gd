extends Node2D
@onready var alert: Node2D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
