extends Node2D


onready var name_label: Label = $NameLabel
onready var arrow_sprite: Sprite = $Arrow

export var speed: float = 600.0
export var hold_on_screen: float = 1.0

signal done_moving
signal about_to_delete(name, arrow)
signal overlapped_arrow(node)


var id

func _ready():
	
	$"%Overlap".connect("area_entered", self, "overlapped_arrow")
	

func set_name(n: String):
	name_label.text = n

# Requests the twitch username based off of the given ID
func request_username(id):
	
	self.id = id
	
	var http = HTTPRequest.new()
	
	add_child(http)
	
	http.request("https://api.twitch.tv/helix/users?id=" + str(id), ["Authorization: Bearer " + Globals.creds.token, "Client-Id:" + Globals.client_id])
	
	http.connect("request_completed", self, "name_request_received", [http])
	

# Connected to the HTTPRequest node used for 
func name_request_received(result, response_code, headers: PoolStringArray, body: PoolByteArray, http):
	
	var info = parse_json(body.get_string_from_utf8())
	
	if info.empty() or info.has("error"):
		
		set_name("Anon")
		
		return
		
	
	info = info.data
	
	if info.empty():
		
		return
		
	
	set_name(info[0].display_name)
	
#	Removes the unneeded HTTPRequest
	http.queue_free()
	


func move_to(to: Vector2):
	var t = create_tween()
	t.tween_property(self, "position", to, Vector2.ZERO.distance_to(to) / speed)
	t.tween_callback(self, "emit_signal", ["done_moving"])
	t.tween_interval(hold_on_screen)
	t.tween_callback(self, "emit_signal", ["about_to_delete", id, self])
	t.tween_callback(self, "queue_free")


func set_speed(s: float):
	speed = s


func set_hold_time(t: float):
	hold_on_screen = t


func set_name_visibility(v: bool):
	name_label.visible = v

func set_overlap_radius(radius : float):
	
	$"%Overlap".get_child(0).shape.radius = radius
	

func set_texture_from_path(p: String):
	if p == "":
		return
		
	var f = File.new()
	if f.open(p, File.READ) == OK:
		var i = Image.new()
		i.load(p)
		var it = ImageTexture.new()
		it.create_from_image(i)
		arrow_sprite.texture = it
	else:
		push_error("Failed to load image file on Arrow")
		
	

func overlapped_arrow(arrow_collider : Area):
	
	emit_signal("overlapped_arrow", self)
	
