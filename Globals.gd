extends Node


signal token_loaded()

const SETTINGS_PATH := "user://settings.tres"


var creds = Creds.new()

var crypto = Crypto.new()

var client_id = "7482xhww2zwe4xkvafq9t89ouucs70"

var settings : Settings = Settings.new()


func _ready():
	
	if ResourceLoader.exists(SETTINGS_PATH):
		
		settings = ResourceLoader.load(SETTINGS_PATH)
		
	else:
		
		settings = Settings.new()
		ResourceSaver.save(SETTINGS_PATH, settings)
		
	
	
	if creds.load_token():
		
		emit_signal("token_loaded")
		
	


func make_state():
	
	return crypto.generate_random_bytes(16).hex_encode()
	
