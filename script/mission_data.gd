class_name MissionData

# For text
var title: String
var description: String

var requirement_count: int

# 5 Stat for checking
var s1: int
var s2: int
var s3: int
var s4: int
var s5: int

func _init(p_title = "ANON_T push name here", p_description = "ANON_D push something here",
p_requirement_count = 2,
p_s1 = 0,
p_s2 = 0,
p_s3 = 0,
p_s4 = 0,
p_s5 = 0):
	title = p_title
	description = p_description
	requirement_count = p_requirement_count
	s1 = p_s1
	s2 = p_s2
	s3 = p_s3
	s4 = p_s4
	s5 = p_s5
	
func setup_by_copy(other: MissionData):
	title = other.title
	description = other.description
	requirement_count = other.requirement_count
	s1 = other.s1
	s2 = other.s2
	s3 = other.s3
	s4 = other.s4
	s5 = other.s5
