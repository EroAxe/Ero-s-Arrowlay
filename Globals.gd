extends Node


signal token_loaded()

const SETTINGS_PATH := "user://settings.tres"


var creds = Creds.new()

var crypto = Crypto.new()

var client_id = "pwe20frjig8obe0qk61gt5o8loxwp8"

var manual_channelid := ""

var settings : Settings = Settings.new()


func _ready():
	
	if ResourceLoader.exists(SETTINGS_PATH):
		
		settings = ResourceLoader.load(SETTINGS_PATH)
		
	else:
		
		settings = Settings.new()
		ResourceSaver.save(SETTINGS_PATH, settings)
		
	
	
	if creds.load_token():
		
		emit_signal("token_loaded")
		
	

func _notification(what):
	
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		
		settings.save()
		
		pass
		
	

func make_state():
	
	return crypto.generate_random_bytes(16).hex_encode()
	
