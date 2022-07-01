extends MarginContainer


func _ready():
	
	get_tree().get_root().transparent_bg = true
	
	
	if Globals.creds.token != "This":
		
		$VBox/Get_Auth.visible = false
		
		$VBox/Start_Overlay.visible = true
		
	


func start_overlay():
	
	get_tree().change_scene("res://Arrow_Overlay.tscn")
	
