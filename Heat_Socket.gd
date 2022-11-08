extends WebSocketClient
class_name Heat_Socket

# Used to hold the URL for heat that we pass the Channel ID to listen through
var heat_url := "wss://heat-api.j38.net/"

func _ready():
	
	if Globals.settings.channel_id == null:
		
		request_channel_id()
		
	


func connect_to_heat():
	
	connect_to_url(heat_url + str(Globals.settings.channel_id))
	
	connect("data_received", self, "socket_received_data")
	


func request_channel_id():
	
	var http = HTTPRequest.new()
	
	Globals.add_child(http)
	
	http.request("https://api.twitch.tv/helix/users", ["Authorization: Bearer " + Globals.creds.token, "Client-Id: " + Globals.client_id])
	
	http.connect("request_completed", self, "channel_id_received", [self])
	


func channel_id_received(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, http):
	
	var info = parse_json(body.get_string_from_utf8())
	
	print(info)
	
	Globals.settings.channel_id = info.data.id
	
	
	connect_to_heat()
	
	http.queue_free()
	


func socket_received_data():
	
	pass
	
