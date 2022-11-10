extends Node


var heat_socket = WebSocketClient.new()

func _ready():
	
	heat_socket.verify_ssl = false
	
	heat_socket.connect_to_url("wss://heat.j38.net/channel/97032862")
	
	heat_socket.connect('data_received', self, 'received_data')
	

func _process(delta):
	
	heat_socket.poll()
	

func received_data():
	
	if !heat_socket.get_peer(0).is_connected_to_host():
		
		return
		
	
	print(heat_socket.get_peer(0).get_packet().get_string_from_utf8())
	
	pass
	
