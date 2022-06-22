extends Node


func _input(event):
	
	if event.is_action("toggle_arrow"):
		
		get_tree().paused = !get_tree().paused
		
		$"../Tween".stop_all()
		
	
