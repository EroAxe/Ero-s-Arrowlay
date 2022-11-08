extends Node2D



export var max_total_arrows: int = 5
export var max_arrows_per_user: int = 1

var arrow_scene = preload("res://Scenes/Arrow.tscn")

var mock_data = """{
	"type": "click",
	"id": "%s",
	"x": "%s",
	"y": "%s"
}"""

var settings : Settings

## Structure:
## {name: [arrow_inst]}
var arrows: Dictionary


func _ready() -> void:
	
	settings = Globals.settings
	
	fullscreen_window()
	


# Fullscreens the window as much as possible.
func fullscreen_window():
	
	OS.window_size = OS.get_screen_size() - Vector2(1,1)
	
	OS.window_position = Vector2(0,0)
	


# Used for debugging based off mouse clicks to emulate Heat packets
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and Engine.editor_hint:
		var mouse_pos = get_viewport().get_mouse_position()
		var nd = mock_data % [randi() % 128, mouse_pos.x / OS.get_window_size().x, mouse_pos.y / OS.get_window_size().y]
		var ndd = parse_json(nd)
		print(float(ndd.x) * OS.get_window_size().x)
		print(float(ndd.y) * OS.get_window_size().y)
		handle_heat_string(nd)


# Handles heat information and moves arrows based off given info.
func handle_heat_string(data: String):
	var dict = parse_json(data)
	
	if dict.type == "system":
		return
	
	if arrows.size() >= settings.max_total_arrows:
		return
	
	var screen_coords: Vector2
	screen_coords.x = float(dict.x) * OS.get_window_size().x
	screen_coords.y = float(dict.y) * OS.get_window_size().y
	
	var username = id_to_name(dict.id)
	
	var cur_arrow
	
	if !arrows.has(username):
		cur_arrow = add_arrow(username)
		arrows[username] = [cur_arrow]
	else:
		if arrows[username].size() < settings.max_arrows_per_user:
			cur_arrow = add_arrow(username)
			arrows[username].append(cur_arrow)
		else:
			return
	
	
	cur_arrow.set_name(username) # Change this to do lookup of ID to get name
	
	cur_arrow.move_to(screen_coords)
	


# Updates settings from the Settings_Dialogs signals with new values
func update_setting(val, setting : String):
	
	settings.set(setting, val)
	


# This is where you would make your Twitch channel ID to Username function, but for now it just returns the id.
func id_to_name(id: String) -> String:
	
	return id
	


# Adds a new arrow instance to the scene and to the arrows dictionary under the specified username.
func add_arrow(username: String) -> Node:
	
	var new_arrow = arrow_scene.instance()
	
	add_child(new_arrow)
	
	new_arrow.set_speed(settings.arrow_speed)
	new_arrow.set_hold_time(settings.arrow_hold_time)
	new_arrow.set_name_visibility(settings.arrow_show_name)
	new_arrow.set_texture_from_path(settings.arrow_texture_path)
	new_arrow.set_overlap_radius(settings.arrow_overlap_radius)
	
	new_arrow.connect("about_to_delete", self, "remove_arrow")
	new_arrow.connect("overlapped_arrow", self, "remove_arrow")
	
	return new_arrow
	


# Removes an arrow from the dictionary of arrows under the specified username of the arrow.
func remove_arrow(username: String, arrow):
	
	if arrows.has(username):
		
		arrows[username].erase(arrow)
		
		if arrows[username].empty():
			
			arrows.erase(username)
			
		
	
