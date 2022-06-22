extends Resource
class_name Creds

var crypto = Crypto.new()

export var token = "This"


func save(token):
	
	self.token = token
	
	
	ResourceSaver.save("user://creds.res", self)
	


func load_token():
	
	var file = File.new()
	
	if file.file_exists("user://creds.res"):
		
		var cred = ResourceLoader.load("user://creds.res") 
		
		token = cred.token
		
		return true
		
	else:
		
		return false
		
	
