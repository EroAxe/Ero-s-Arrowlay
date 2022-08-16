extends MarginContainer


var heat_socket = WebSocketClient.new()

var channel_id

onready var arrow : Sprite = $Arrow

onready var tween : Tween = $Tween

onready var http : HTTPRequest = $HTTPRequest

export var start_pos = Vector2(0,0)


var on_cooldown = false

var disabled = false


func _ready():
	
	heat_socket.verify_ssl = false
	
	OS.window_size = OS.get_screen_size() - Vector2(1,1)
	
	OS.window_position = Vector2(0,0)
	
	
#	OS.set_window_always_on_top(true)
	
	get_tree().get_root().transparent_bg = true
	
	
	request_id()
	
	
	heat_socket.connect("data_received", self, "heat_click")
	
	heat_socket.connect("connection_established", self, "connected")
	
	heat_socket.connect("connection_closed", self, "socket_closed")
	
#	TODO: Auto boot the AutoHotkey Script
	var ahk_script = OS.get_executable_path().get_base_dir().plus_file("Overlay Toggle.ahk")

	OS.shell_open(ahk_script)
	

func _process(delta):
	
	if !disabled:
		
		heat_socket.poll()
		
	

# Handles reconnecting to heat when needed on a timer
func reconnect():
	
	if !heat_socket.get_peer(1).is_connected_to_host():
		
		connect_to_heat()
		
	

# Requests the Channel ID from Twitch
func request_id():
	
	var requester = HTTPRequest.new()
	
	add_child(requester)
	
	requester.connect("request_completed", self, "id_received")
	
	requester.request("https://api.twitch.tv/helix/users?", 
		[
			
			"Authorization: Bearer " + Globals.creds.token,
			"Client-Id: " + Globals.client_id
			
		])
	

# Connected to HTTPRequest when ID request is completed
func id_received(result, response, headers, body):
	
	var info = parse_json(body.get_string_from_utf8())
	
	if info.has("error"):
		
		push_error("Authentication Error Received: " + info.message)
		
		return
		
	
	info.data = info.data[0]
	
	channel_id = info.data.id
	
	
	connect_to_heat()
	

# Connects to the Heat Extension on a specific channel
func connect_to_heat():
	
	heat_socket.connect_to_url("wss://heat-api.j38.net/channel/" + str(channel_id))
	

func connected(protocol):
	
	print("Connected to Heat!")
	

# Connected to the heat websocket when clicks come through
func heat_click():
	
	var packet = heat_socket.get_peer(1).get_packet()
	
	var info = parse_json(packet.get_string_from_utf8())
	
	print(info)
	
	
	if info.type == "system":
		
		print(info.message)
		
		return
		
	
	$Hider.stop()
	
	var window_size = OS.window_size
	
	var goal_pos = Vector2(float(info.x) * window_size.x, float(info.y) * window_size.y)
	
	if !on_cooldown:
		
		var time = start_pos.distance_to(goal_pos) /600
		
		print(start_pos, goal_pos, "Time ", str(time))
		
		get_username(info.id)
		
		tween.interpolate_property(arrow, "position", start_pos, goal_pos, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		
		tween.start()
		
		#arrow.visible = true
		
		yield(tween, "tween_started")
		
		on_cooldown = true
		
	

func get_username(id):
	
	http.request("https://api.twitch.tv/helix/users?id=" + id, [
		
		"Authorization: Bearer " + Globals.creds.token,
		"Client-Id: " + Globals.client_id
		
	])
	

func check_http(result, response_code, headers, body):
	
	var info = body.get_string_from_utf8()
	
	info = parse_json(info)
	
	if info.has("error"):
		
		$Arrow/Label.text = ""
		
		push_error("Received Bad Request on get_username.  Someone may not have authorized Heat.")
		
		return
		
	
	var data = info.data[0]
	
	print(data.display_name)
	
	$Arrow/Label.text = data.display_name
	

""" HELPER FUNCTIONS """

func start_cooldown(object, key):
	
	print("Started Arrow Cooldown" + " - " + str(OS.get_system_time_secs()))
	
	$Cooldown.start()
	
	$Hider.start()
	

func cooldown_over():
	
	print("Arrow cooldown over" + " - " + str(OS.get_system_time_secs()))
	
	on_cooldown = false
	
	#arrow.visible = false
	

func toggle_arrow(thing):
	
	disabled != disabled
	
	print("Arrow Toggled : " + str(disabled) + " - " + str(OS.get_system_time_secs()))
	
	
	$MarginContainer/Indicator.visible = !$MarginContainer/Indicator.visible
	

func socket_closed(was_clean):
	
	print("Heat_Socket Disconnected" + " - " + str(OS.get_system_time_secs()))
	
	connect_to_heat()
	


func move_offscreen():
	
	arrow.position = Vector2(-20, 0)
	
	print("Arrow Hidden" + str(OS.get_system_time_secs()))
	
	$Arrow/Label.text = ""
	


