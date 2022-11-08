extends WindowDialog

onready var http : HTTPRequest = $http


signal token_valid()


func _ready():
	
	http.connect("request_completed", self, "http_check_complete")
	
	$"%Token_Popup_Input".connect("text_changed", self, "set_manual_popup_token")
	
	$"%Port_Popup_Input".connect("text_changed", self, "set_manual_popup_port")
	

# Connected to Get_Auths got_token function.  Assumes it has a valid token 
func got_valid_token():
	
	get_tree().paused = false
	hide()
	

func check_token():
	
	if Globals.creds.token == "This":
		
		push_error("Nonexistent Token")
		
		return
		
	
	http.request('https://id.twitch.tv/oauth2/validate', 
				["Authorization: Bearer " + Globals.creds.token])
	

# Connected to HTTPRequests request_completed signal for checking if the token that was passed to twitch is valid 
func http_check_complete(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	
	var info = parse_json(body.get_string_from_utf8())
	
#	Checks that the result was correct and that the correct info was supplied to ensure that the token is valid and avoid twitch weirdness
	if response_code == 200 and info.has("scopes") and info.has("login"):
		
		print("Valid Token Received")
		
		emit_signal("token_valid")
		
		return true
		
	
	get_tree().paused = true
	
	popup()
	

func set_manual_popup_token(token : String):
	
	Globals.creds.token = token
	
	Globals.creds.save()
	

func set_manual_popup_port(port):
	
	Globals.settings.authentication_port = port
	
