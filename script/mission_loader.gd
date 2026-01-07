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
		var line := file.get_line()
		if line.strip_edges().is_empty():
			continue

		var row: Array = []
		var field := ""
		var in_quotes := false
		var i := 0

		while i < line.length():
			var c := line[i]

			if c == '"':
				if in_quotes and i + 1 < line.length() and line[i + 1] == '"':
					# Escaped quote ("")
					field += '"'
					i += 1
				else:
					# Enter / exit quoted field
					in_quotes = !in_quotes
			elif c == delimiter and not in_quotes:
				row.append(field)
				field = ""
			else:
				field += c

			i += 1

		# Append last field
		row.append(field)
		rows.append(row)

	file.close()
	return rows
	
func parse_missions():
	var mission_rows = import_csv(mission_csv_path)
	var mission_rows_no_header = mission_rows.slice(1, mission_rows.size())
	
	mission_data_pool.clear()
	
	for mission_row in mission_rows_no_header:
		# Intiate mission_data from mission_row
		print("[PARSE MISSION]")
		var mission_data = MissionData.new(
			mission_row[0], 
			mission_row[1], 
			int(mission_row[2]), 
			int(mission_row[3]), 
			int(mission_row[4]), 
			int(mission_row[5]),
			int(mission_row[6]), 
			int(mission_row[7]))
			
		print("Title: %s" % [mission_data.title])
		print("Description: %s" % [mission_data.description])
		print("Requirement Count: %s" % [mission_data.requirement_count])	
		
		# Add new mission only when requirement_count is positive
		if mission_data.requirement_count > 0:
			mission_data_pool.append(mission_data)
	mission_loading_complete_signal.emit()
		
func pick_one_random_mission() -> MissionData:
	# Obtain random index of mission_pool
	var random_index: int = randi_range(0, mission_data_pool.size() - 1)
	return mission_data_pool[random_index]
	
