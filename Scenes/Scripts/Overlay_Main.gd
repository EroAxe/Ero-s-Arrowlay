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

## Structure:
## {name: [arrow_inst]}
var arrows: Dictionary

var heat_socket := Heat_Socket.new()


func _ready() -> void:
	
	fullscreen_window()
	
	start_heat()
	
	OS.shell_open(OS.get_executable_path().get_base_dir().plus_file("Arrowlay Toggle.exe"))
	
	print_debug(OS.get_executable_path().get_base_dir().plus_file("Overlay Toggle.ahk"))
	

func reload_heat():
	
	heat_socket = Heat_Socket.new()
	
	start_heat()
	

func start_heat():
	
	heat_socket.connect("connection_closed", $Reload_Timer, "start")
	
	heat_socket.connect("connection_established", $Reload_Timer, "stop")
	
	heat_socket.connect("heat_data", self, "handle_heat_string")
	
	if Globals.manual_channelid.empty():
		
		request_channel_id()
		
	else:
		
		heat_socket.connect_to_heat(Globals.manual_channelid)
		
	


func _process(delta):
	
	heat_socket.poll()
	

func heat_reconnect_timer_ended():
	
	print_debug(Time.get_datetime_dict_from_system(), ": Reconnecting to heat")
	
	heat_socket.disconnect_from_host()
	

## Connected to Reload_Timer node to reload heat if it doesn't reconnect itself when the connection closes.
func reload_timer_ended():
	
	reload_heat()
	

# Fullscreens the window as much as possible.
func fullscreen_window():
	
	OS.window_size = OS.get_screen_size() - Vector2(1,1)
	
	OS.window_position = Vector2(0,0)
	


# Used for debugging based off mouse clicks to emulate Heat packets
func _input(event: InputEvent) -> void:
	print(Engine.editor_hint)
	
	if event is InputEventMouseButton and event.pressed and OS.is_debug_build() and Engine.editor_hint:
		
		var mouse_pos = get_viewport().get_mouse_position()
		var nd = mock_data % [heat_socket.reconnect_id, mouse_pos.x / OS.get_window_size().x, mouse_pos.y / OS.get_window_size().y]
		var ndd = parse_json(nd)
		print(float(ndd.x) * OS.get_window_size().x)
		print(float(ndd.y) * OS.get_window_size().y)
		handle_heat_string(nd, true)
		
	
	if event.is_action("reload_heat"):
		
		reload_heat()
		
	


func request_channel_id():
	
	var http = HTTPRequest.new()
	
	add_child(http)
	
	http.request("https://api.twitch.tv/helix/users", ["Authorization: Bearer " + Globals.creds.token, "Client-Id: " + Globals.client_id])
	
	http.connect("request_completed", self, "channel_id_received", [http])
	


func channel_id_received(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http):
	
	var info = parse_json(body.get_string_from_utf8())
	
	print(info)
	
	
	heat_socket.connect_to_heat(info.data[0].id)
	
	http.queue_free()
	


# Handles heat information and moves arrows based off given info.
func handle_heat_string(data: String, arrow_visible_override = false):
	var dict = parse_json(data)
	
	$Reconnect_Timer.start()
	
	prints(Time.get_datetime_string_from_system(), ": ", "Heat System ", data)
	
	if dict.type == "system":
		
		print(dict)
		
		return
	
	prints(Time.get_datetime_string_from_system(), ": ", "Heat Click ", data)
	
	if arrows.size() >= Globals.settings.max_total_arrows:
		return
	
	var screen_coords: Vector2
	screen_coords.x = float(dict.x) * OS.get_window_size().x
	screen_coords.y = float(dict.y) * OS.get_window_size().y
	
	prints(Time.get_datetime_string_from_system(), ": ", "Heat Target: ", str(screen_coords))
	
	print(dict.id)
	print(Globals.settings.max_arrows_per_user)
	
	var cur_arrow
	
	if !arrows.has(dict.id):
		cur_arrow = add_arrow(dict.id, arrow_visible_override)
		arrows[dict.id] = [cur_arrow]
	else:
		if arrows[dict.id].size() < Globals.settings.max_arrows_per_user:
			cur_arrow = add_arrow(dict.id)
			arrows[dict.id].append(cur_arrow)
		else:
			return
			
	
	cur_arrow.request_username(dict.id)
	
	cur_arrow.move_to(screen_coords)
	


# Adds a new arrow instance to the scene and to the arrows dictionary under the specified username.
func add_arrow(username: String, arrow_vis_override = false) -> Node:
	
	var new_arrow = arrow_scene.instance()
	
	add_child(new_arrow)
	
	if !arrow_vis_override:
		new_arrow.set_name_visibility(Globals.settings.arrow_show_name)
	
	new_arrow.set_speed(Globals.settings.arrow_speed)
	new_arrow.set_hold_time(Globals.settings.arrow_hold_time)
	new_arrow.set_texture_from_path(Globals.settings.arrow_texture_path)
	new_arrow.set_overlap_radius(Globals.settings.arrow_overlap_radius)
	
	new_arrow.connect("about_to_delete", self, "remove_arrow")
	new_arrow.connect("overlapped_arrow", self, "remove_arrow")
	
	return new_arrow
	


# Removes an arrow from the dictionary of arrows under the specified username of the arrow.
func remove_arrow(username: String, arrow):
	
	if arrows.has(username):
		
		arrows[username].erase(arrow)
		
		if arrows[username].empty():
			
			arrows.erase(username)
			
		
	
