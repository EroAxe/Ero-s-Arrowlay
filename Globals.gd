extends Node


signal token_loaded()


var creds = Creds.new()

var crypto = Crypto.new()

var client_id = "7482xhww2zwe4xkvafq9t89ouucs70"



func _ready():
	
	if creds.load_token():
		
		emit_signal("token_loaded")
		
	


func make_state():
	
	return crypto.generate_random_bytes(16).hex_encode()
	
