extends Resource
class_name Settings


export var max_total_arrows : int = 3
export var max_arrows_per_user : int = 1
export var arrow_speed : float = 600.0
export var arrow_hold_time : float = 1.0
export var arrow_show_name : bool = true
export var arrow_overlap_radius : float = 25.0

export var arrow_texture_path: String

export var authentication_port : int = 80


func set_setting(whatever : String, val):
	
	set(whatever, val)
	

func save():
	
	ResourceSaver.save("user://settings.res", self)
	


