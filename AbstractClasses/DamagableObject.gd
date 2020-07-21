extends IsoObject
class_name DamagableObject

const LIFEBAR_SCENE = preload("res://Scenes/Combat/LifeBar/LifeBar.tscn")

var current_HP : int = 0 setget set_current_HP, get_current_HP
var max_HP : int = 0 setget set_max_HP, get_max_HP

var lifebar : Control
var clickable_area : Area2D

signal focused
signal unfocused

#### ACCESSORS ####

func set_current_HP(value: int):
	current_HP = value

func get_current_HP() -> int:
	return current_HP

func set_max_HP(value: int):
	max_HP = value

func get_max_HP() -> int:
	return max_HP

#### BUILT-IN FUNCTIONS ####

func _ready():
	yield(owner, "ready")
	
	var _err = connect("focused", owner, "on_object_focused")
	_err = connect("unfocused", owner, "on_object_unfocused")
	
	
	generate_lifebar()
	generate_clickable_area()


#### LOGIC ####

func generate_lifebar():
	lifebar = LIFEBAR_SCENE.instance()
	var sprite_height = $Sprite.get_texture().get_size().y
	lifebar.set_position(Vector2(0, -sprite_height - 5))
	lifebar.set_visible(false)
	add_child(lifebar)

# Generate the area that will detect the mouse going over the sprite
func generate_clickable_area():
	clickable_area = Area2D.new()
	add_child(clickable_area)
	clickable_area.set_position($Sprite.get_position())
	
	var collision_shape = CollisionShape2D.new()
	
	var rect_shape = RectangleShape2D.new()
	var sprite_size = $Sprite.get_texture().get_size()
	rect_shape.set_extents(sprite_size / 2)
	
	collision_shape.set_shape(rect_shape)
	
	clickable_area.add_child(collision_shape)

	var _err = clickable_area.connect("mouse_entered", self, "_on_mouse_entered")
	_err = clickable_area.connect("mouse_exited", self, "_on_mouse_exited")


# Show the known actors infos
func show_infos():
	lifebar.update()
	lifebar.set_visible(true)
	emit_signal("focused", self)

# Hide the infos 
func hide_infos():
	lifebar.set_visible(false)
	emit_signal("unfocused", self)


func destroy():
	remove_from_group("IsoObject")
	emit_signal("destroyed")
	emit_signal("unfocused", self)
	queue_free()

#### SIGNAL RESPONSES ####

func _on_mouse_entered():
	show_infos()

func _on_mouse_exited():
	hide_infos()
