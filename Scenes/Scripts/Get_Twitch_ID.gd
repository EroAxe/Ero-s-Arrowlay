extends Button


onready var http = $HTTPRequest

var username : String

func _ready():
	
	http.connect("request_completed", self, "id_received")
	

func _pressed():
	
	http.request("https://api.twitch.tv/helix/users?login=" + username,
			["Authorization: Bearer " + Globals.creds.token, "Client-Id: " + Globals.client_id])
	

func id_received(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	
	var info = parse_json(body.get_string_from_utf8())
	
	print(info.data[0].id)
	


func set_manual_username(new_text):
	
	username = new_text
	
