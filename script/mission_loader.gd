class_name MissionLoader
extends Node

var mission_data_pool: Array[MissionData]

@export_file("*.csv") var  mission_csv_path: String

signal mission_loading_complete_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mission_data_pool = []
	parse_missions()

func import_csv(path: String, delimiter: String = ",") -> Array:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Cannot open CSV file: %s" % path)
		return []

	var rows: Array = []

	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == "":
			continue

		var fields = line.split(delimiter)
		rows.append(fields)

	file.close()
	return rows
	
func parse_missions():
	var mission_rows = import_csv(mission_csv_path)
	var mission_rows_no_header = mission_rows.slice(1, mission_rows.size())
	for mission_row in mission_rows_no_header:
		# Intiate mission_data from mission_row
		var mission_data = MissionData.new(
			mission_row[0], 
			mission_row[1], 
			int(mission_row[2]), 
			int(mission_row[3]), 
			int(mission_row[4]), 
			int(mission_row[5]),
			int(mission_row[6]), 
			int(mission_row[7]))
		mission_data_pool.append(mission_data)
	mission_loading_complete_signal.emit()
		
func pick_one_random_mission() -> MissionData:
	# Obtain random index of mission_pool
	var random_index: int = randi_range(0, mission_data_pool.size() - 1)
	return mission_data_pool[random_index]
	
