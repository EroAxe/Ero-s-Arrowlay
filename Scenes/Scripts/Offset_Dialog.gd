extends Control

onready var arrow : TextureRect = $"%Arrow_Node"

var orig_offset : Vector2

func _ready():
	orig_offset = Vector2(Globals.settings.arrow_x_offset, Globals.settings.arrow_y_offset)
	

func open_offset_dialog():
	
	var file = File.new()
	var err = file.open(Globals.settings.arrow_texture_path, File.READ)
	if err != OK:
		
		push_error("Texture Load Error: Arrow Texture Path Unable to load, please check the path you have set for the arrow.")
		return
		
	var arrow_image = load(Globals.settings.arrow_texture_path)
	var size = arrow_image.get_size()
	
	arrow.texture = arrow_image
	arrow.rect_position = Vector2(Globals.settings.arrow_x_offset, Globals.settings.arrow_y_offset) 
	
	$Panel_Box.rect_size = size
	
	visible = true
	

func update_offset(setting, val):
	
	if "x" in setting:
		
		update_x_offset(val)
		return
		
	
	update_y_offset(val)

func update_x_offset(val):
	
	arrow.rect_position.x = val
	

func update_y_offset(val):
	
	arrow.rect_position.y = val
	

