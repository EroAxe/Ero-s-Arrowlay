extends Resource
class_name Creds

var crypto = Crypto.new()

export var token = "This"

const creds_path = "user://creds.tres"

func save(token):
	print("A: ", token)
	self.token = token
	
	
	ResourceSaver.save(creds_path, self)
	


func load_token():
	
	var file = File.new()
	
	if file.file_exists(creds_path):
		
		var cred = ResourceLoader.load(creds_path) 
		
		token = cred.token
		
		return true
		
	else:
		
		return false
		
	
