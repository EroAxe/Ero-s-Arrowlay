extends WebSocketClient
class_name Heat_Socket


# Used to hold the URL for heat that we pass the Channel ID to listen through
var heat_url := "wss://heat-api.j38.net/channel/"

var is_connected := false

signal heat_data(info)

func _ready():
	
	verify_ssl = false
	

func connect_to_heat():
	
#	connect_to_url(heat_url + str(Globals.settings.channel_id))
	
	connect_to_url(heat_url + str(144606537))
	
	connect("data_received", self, "socket_received_data")
	
	connect("connection_established", self, "socket_connected")
	

func socket_connected(proto):
	
	print("Heat Socket Connected")
	
	is_connected = true
	

func socket_received_data():
	
	var info = parse_json(get_peer(0).get_packet().get_string_from_utf8())
	
	emit_signal("heat_data", info)
	
