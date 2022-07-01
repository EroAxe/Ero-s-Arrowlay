extends MarginContainer


var heat_socket = WebSocketClient.new()

var channel_id

onready var arrow : Sprite = $Arrow

onready var tween : Tween = $Tween

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
	

func _process(delta):
	
	if !disabled:
		
		heat_socket.poll()
		
	

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
		
	
	var window_size = OS.window_size
	
	var goal_pos = Vector2(float(info.x) * window_size.x, float(info.y) * window_size.y)
	
	if !on_cooldown:
		
		var time = start_pos.distance_to(goal_pos) /600
		
		print(start_pos, goal_pos, "Time ", str(time))
		
		tween.interpolate_property(arrow, "position", start_pos, goal_pos, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		
		tween.start()
		
		
		yield(tween, "tween_started")
		
		$Arrow.visible = true
		
		on_cooldown = true
		
	


func start_cooldown(object, key):
	
	$Cooldown.start()
	

func cooldown_over():
	
	on_cooldown = false
	
	$Arrow.visible = false
	

func toggle_arrow(thing):
	
	disabled != disabled
	
	$MarginContainer/Indicator.visible = !$MarginContainer/Indicator.visible
	
