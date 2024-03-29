extends Button



""" CONNECTOR VARIABLES """

var server = TCP_Server.new()

""" LOCAL VARIABLES """

var auth_requested = false

var requesting

var state = Globals.make_state()


signal got_token


func pressed():
	
	var url = "http://localhost"
	
	print(Globals.settings.authentication_port)
	
	if Globals.settings.authentication_port != null and Globals.settings.authentication_port != 80:
		
		url += ":" + str(Globals.settings.authentication_port)
		
	
	server.listen(Globals.settings.authentication_port)
	
	OS.shell_open("https://id.twitch.tv/oauth2/authorize?" +
			"response_type=token&client_id=" + Globals.client_id + 
			"&redirect_uri=" + url + "&scope=chat%3Aread&state=" + state)
	
	auth_requested = true
	

func _process(delta):
	
	if auth_requested and server.is_connection_available():
		
		check_server()
		
	

""" CHECK FUNCTIONS """

# Handles checking responses on the TCP_Server.  Specifically for authentication token from Twitch when grabbing it.
func check_server():
	
	var peer = server.take_connection()
	
	var bytes = peer.get_available_bytes()
	
	
	var info = peer.get_utf8_string(bytes)
	
	
#	Creates a javascript line in HTML to fetch the "hash" or "fragment" of the URL and send it back
	var script = "<script>fetch('http://localhost/' + window.location.hash.substr(1))</script>"
	
#	Puts that script on the connected "peer", AKA "sends" it (?)
	peer.put_data(str("HTTP/1.1 200\n\n" + script).to_ascii())
	
	
	print(info)
	
#	Splits the state out of the info string.  Then if it was actuually there it splits off the "&token_type" at the end
#	which allows pulling the state and only the state
	var res_state = info.split("&state=")
	
#	Returns the function if the res_state is too small to have the actual state
	if !res_state.size() > 1:
		
		return
		
	
	
	res_state = res_state[1].split("&")[0]
	
	
	
#	Checks if the received state is the same state as the one saved locally.  If so it grabs the token out
	if res_state == state:
		
#		Splits the info by access_token= to get the token out.  Then splits it by & to remove the scopes
		var token = info.split("access_token=")[1]
		
		token = token.split("&")[0]
		
#		Saves the token to creds in Globals + to the local file system
		Globals.creds.save(token)
		
#		Stops the server listening
		server.stop()
		
		emit_signal("got_token")
		
	

