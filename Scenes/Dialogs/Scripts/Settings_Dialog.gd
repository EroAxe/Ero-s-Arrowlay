extends WindowDialog


signal update_setting(val, setting_to_update)

func _ready():
	
#	Connects setting Controls with their respective settings as binds to update_settings for passing all setting updates through the function
	$"%Max_Arrows".connect("value_changed", self, "update_setting", ["max_total_arrows"])
	
	$"%User_Arrows".connect("value_changed", self, "update_setting", ["max_arrows_per_user"])
	
	$"%Arrow_Speed".connect("value_changed", self, "update_setting", ["arrow_speed"])
	
	$"%Arrow_Hold".connect("value_changed", self, "update_setting", ["arrow_hold_time"])
	
	$"%Show_Name".connect("toggled", self, "update_setting", ["arrow_show_name"])
	
	$"%Arrow_Path".connect("file_selected", self, "update_setting", ["arrow_texture_path"])
	


func _input(event):
	
	if event.is_action("toggle_clickthrough"):
		
		$"%Clickthrough".visible = !$"%Clickthrough".visible
		
	
	if event.is_action("settings"):
		
		popup(Rect2(get_global_mouse_position(), rect_size))
		
	


func update_setting(val, setting : String):
	
	Globals.settings.set(setting, val)
	
