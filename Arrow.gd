extends Sprite


export var heat_pos : Vector2 setget update_clickthrough

func _ready():
	
	heat_pos = position
	

func _process(delta):
	
	position = heat_pos
	

func update_clickthrough(heat_pos):
	
	var tex_size = texture.get_size() / 2
	
	var arr_pos = heat_pos
	
	OS.set_window_mouse_passthrough(
		[
			
			Vector2(arr_pos.x - tex_size.x, arr_pos.y - tex_size.y),
			Vector2(arr_pos.x + tex_size.x, arr_pos.y - tex_size.y),
			Vector2(arr_pos.x - tex_size.x, arr_pos.y + tex_size.y),
			Vector2(arr_pos.x + tex_size.x, arr_pos.y + tex_size.y),
			
		])
	
