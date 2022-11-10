extends WebSocketClient
class_name Heat_Socket


# Used to hold the URL for heat that we pass the Channel ID to listen through
var heat_url := "wss://heat-api.j38.net/channel/"

signal heat_data(info)


func connect_to_heat(channel_id):
	
	connect("data_received", self, "socket_received_data")
	
	connect("connection_established", self, "socket_connected")
	
	print(heat_url + str(channel_id))
	
	connect_to_url(heat_url + str(channel_id))
	

func socket_connected(proto):
	
	print("Heat Socket Connected")
	

func socket_received_data():
	
	var info = get_peer(1).get_packet().get_string_from_utf8()
	
	emit_signal("heat_data", info)
	
