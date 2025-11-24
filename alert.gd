extends Node2D
signal open_screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_cursor_hand():
	self.scale = Vector2(1.05,1.05)
	
func change_cursor_back():
	self.scale = Vector2(1,1)
	
func open_select_screen(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("open_screen")
		print("emit COMPLETE")
