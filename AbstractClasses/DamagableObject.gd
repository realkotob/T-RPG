extends IsoObject
class_name DamagableObject

const LIFEBAR_SCENE = preload("res://Scenes/Combat/LifeBar/LifeBar.tscn")

export var max_HP : int = 0 setget set_max_HP, get_max_HP
var current_HP : int = 0 setget set_current_HP, get_current_HP

export var defense : int = 0 setget set_defense, get_defense

var lifebar : Control
var clickable_area : Area2D

signal focused
signal unfocused
signal hurt_animation_finished

#### ACCESSORS ####

func set_current_HP(value: int):
	if value >= 0 && value <= get_max_HP() && value != current_HP:
		current_HP = value

func get_current_HP() -> int: return current_HP

func set_max_HP(value: int):
	max_HP = value

func get_max_HP() -> int: return max_HP

func set_defense(value: int):
	defense = value

func get_defense() -> int:
	return defense

#### BUILT-IN FUNCTIONS ####

func _ready():
	yield(owner, "ready")
	
	var _err = connect("focused", owner, "on_object_focused")
	_err = connect("unfocused", owner, "on_object_unfocused")
	
	current_HP = max_HP
	
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
	if is_currently_visible():
		lifebar.update()
		lifebar.set_visible(true)
		emit_signal("focused", self)

# Hide the infos 
func hide_infos():
	lifebar.set_visible(false)
	emit_signal("unfocused", self)


func hurt(damage: int):
	set_current_HP(get_current_HP() - damage)
	$AnimationPlayer.play("RedFlash")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("hurt_animation_finished")
	
	if get_current_HP() == 0:
		destroy()

func destroy():
	emit_signal("unfocused", self)
	EXPLODE.scatter_sprite(self, 16)
	.destroy()


#### SIGNAL RESPONSES ####

func _on_mouse_entered():
	if not self == owner.active_actor:
		show_infos()

func _on_mouse_exited():
	if not self == owner.active_actor:
		hide_infos()
