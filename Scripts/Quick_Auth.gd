extends Button

# Test Button to see if quick authentication through HTTPS can work, currently doesn't work and unsure as to why, possibly due to Twitch blocking it through something in HTTPS.

onready var http : HTTPRequest = $HTTPRequest

var state = Globals.make_state()

func _ready():
	
	http.connect("request_completed", self, "http_auth_complete")
	
	connect("pressed", self, "quick_authenticate_twitch")
	

func quick_authenticate_twitch():
	
	http.request("https://id.twitch.tv/oauth2/authorize?" +
			"response_type=token&client_id=" + Globals.client_id + 
			"&redirect_uri=http://localhost&scope=chat%3Aread chat%3Aedit&state=" + state)
	

func http_auth_complete(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	
	var info = body.get_string_from_utf8()
	
	print(info)
	
