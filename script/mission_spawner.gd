class_name MissionSpawner
extends Node

@export var mission_loader: MissionLoader
@export var spawn_rate_second: float
@export var spawn_timer: Timer
@export var min_rect_spawn_vector2: Vector2
@export var max_rect_spawn_vector2: Vector2

var is_ready: bool = false

var select_screen_scene: PackedScene = load("res://scene/alert_select_screen.tscn")
const SPAWN_DEFAULT_POS: Vector2 = Vector2(950, 530)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_mission_on_position(position: Vector2):
	var spawned = select_screen_scene.instantiate()
	add_child(spawned)
	spawned.global_position = position
	if is_instance_of(spawned, AlertSelectScreen):
		# Find select_sreen
		var alert_select_screen: AlertSelectScreen = spawned
		var select_screen = alert_select_screen.select_screen
		# Get new random mission
		var new_mission = mission_loader.pick_one_random_mission()
		# Setup
		select_screen.set_new_mission(new_mission)

func pick_random_spawn_position() -> Vector2:
	var rand_x = randf_range(min_rect_spawn_vector2.x, max_rect_spawn_vector2.x)
	var rand_y = randf_range(min_rect_spawn_vector2.y, max_rect_spawn_vector2.y)
	return Vector2(rand_x, rand_y)

func spawn_one_mission_on_default_pos():
	spawn_mission_on_position(SPAWN_DEFAULT_POS)

func on_mission_loading_complete():
	print("loading complete")
	is_ready = true
	spawn_timer.start()


func _on_timer_timeout() -> void:
	if is_ready:
		print("spawn")
		spawn_mission_on_position(pick_random_spawn_position())
