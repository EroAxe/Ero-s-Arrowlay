extends WindowDialog

export var overlay_path : NodePath

onready var overlay = get_node(overlay_path)


func _unhandled_key_input(event):
	
	if event.is_action_released("toggle_arrow"):
		
		overlay.toggle_arrow(false)
		
	

func _input(event):
	
	if event.is_action("settings"):
		
		popup()
		
	
