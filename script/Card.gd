extends Node2D

signal hovered
signal hovered_off

@export
var stat_screen: Node2D

var inhand_pos: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# all cards must be the child of the cardmanager!!!
	connect_hovering_signal_with_parent()
	#$"TextureProgressBar".visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func connect_hovering_signal_with_parent() -> void:
	get_parent().connect_card_signal(self)

func show_stat_screen() -> void:
	stat_screen.visible = true
	
func hide_stat_screen() -> void:
	stat_screen.visible = false

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)
	show_stat_screen()


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	hide_stat_screen()


	
