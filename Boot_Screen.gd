extends MarginContainer


func _ready():
	
	get_tree().get_root().transparent_bg = true
	
	
	if Globals.creds.token != "This":
		
		$HBoxContainer/Get_Auth.visible = false
		
		$HBoxContainer/Start_Overlay.visible = true
		
	


func start_overlay():
	
	get_tree().change_scene("res://Arrow_Overlay.tscn")
	
