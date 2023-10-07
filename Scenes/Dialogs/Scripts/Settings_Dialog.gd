extends WindowDialog


signal update_setting(val, setting_to_update)
signal update_offset(setting, val)

func _ready():
	
#	Connects setting Controls with their respective settings as binds to update_settings for passing all setting updates through the function
	$"%Max_Arrows".connect("value_changed", self, "update_setting", ["max_total_arrows"])
	
	$"%User_Arrows".connect("value_changed", self, "update_setting", ["max_arrows_per_user"])
	
	$"%Arrow_Speed".connect("value_changed", self, "update_setting", ["arrow_speed"])
	
	$"%Arrow_Hold".connect("value_changed", self, "update_setting", ["arrow_hold_time"])
	
	$"%Show_Name".connect("toggled", self, "update_setting", ["arrow_show_name"])
	
	$"%Arrow_Path".connect("file_selected", self, "update_setting", ["arrow_texture_path"])
	
	$"%Arrow_X_Offset".connect("value_changed", self, "update_setting", ["arrow_x_offset"])
	
	$"%Arrow_Y_Offset".connect("value_changed", self, "update_setting", ["arrow_y_offset"])
	
	$"%Arrow_Text_Size".connect("value_changed", self, "update_setting", ["arrow_text_size"])
	
	load_settings()
	

func load_settings():
	
	$"%Max_Arrows".value = Globals.settings.max_total_arrows
	$"%User_Arrows".value = Globals.settings.max_arrows_per_user
	
	$"%Arrow_Speed".value = Globals.settings.arrow_speed
	$"%Arrow_Hold".value = Globals.settings.arrow_hold_time
	$"%Arrow_Overlap".value = Globals.settings.arrow_overlap_radius
	
	$"%Show_Name".pressed = Globals.settings.arrow_show_name
	
	$"%Arrow_X_Offset".value = Globals.settings.arrow_x_offset
	$"%Arrow_Y_Offset".value = Globals.settings.arrow_y_offset
	


func _input(event):
	
	if event.is_action("toggle_clickthrough"):
		
		$"%Clickthrough".visible = !$"%Clickthrough".visible
		
	
	if event.is_action("settings"):
		
		popup(Rect2(get_global_mouse_position(), rect_size))
		
	


func update_setting(val, setting : String):
	
#	if "offset" in setting:
#
#		emit_signal("update_setting", setting, val)
#
	
	Globals.settings.set(setting, val)
	


func open_path_dialog():
	
	$"%Arrow_Path".popup(Rect2(get_global_mouse_position(), $"%Arrow_Path".rect_size))
	

func save_settings_on_close():
	
	Globals.settings.save()
	
