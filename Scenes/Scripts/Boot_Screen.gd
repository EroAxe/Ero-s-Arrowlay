extends MarginContainer


func _ready():
	
	get_tree().get_root().transparent_bg = true
	
	
	if Globals.creds.token != "This":
		
		$VBox/Get_Auth.visible = false
		
		$VBox/Start_Overlay.visible = true
		
	


func start_overlay():
	
	get_tree().change_scene("res://Scenes/Overlay_Main.tscn")
	

func set_manual_token(token : String):
	
	Globals.creds.token = token
	
	Globals.creds.save()
	


func set_manual_port(port):
	
	Globals.settings.authentication_port = int(port)
	
