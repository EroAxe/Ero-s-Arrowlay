extends Node2D


onready var name_label: Label = $NameLabel
onready var arrow_sprite: Sprite = $Arrow

export var speed: float = 600.0
export var hold_on_screen: float = 1.0

signal done_moving
signal about_to_delete(name, arrow)
signal overlapped_arrow(node)


func _ready():
	
	$"%Overlap".connect("area_entered", self, "overlapped_arrow")
	

func set_name(n: String):
	name_label.text = n


func move_to(to: Vector2):
	var t = create_tween()
	t.tween_property(self, "position", to, Vector2.ZERO.distance_to(to) / speed)
	t.tween_callback(self, "emit_signal", ["done_moving"])
	t.tween_interval(hold_on_screen)
	t.tween_callback(self, "emit_signal", ["about_to_delete", name_label.text, self])
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
	
