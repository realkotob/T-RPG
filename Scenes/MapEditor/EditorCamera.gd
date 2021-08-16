extends Camera2D
class_name EditorCamera

var drag : bool = false setget set_drag, is_drag
var clicked_pos = Vector2.INF setget set_clicked_pos, get_clicked_pos

#### ACCESSORS ####

func is_class(value: String): return value == "EditorCamera" or .is_class(value)
func get_class() -> String: return "EditorCamera"

func set_drag(value: bool): drag = value
func is_drag() -> bool: return drag

func set_clicked_pos(value: Vector2): clicked_pos = value
func get_clicked_pos() -> Vector2: return clicked_pos  


#### BUILT-IN ####

func _process(_delta: float) -> void:
	if !drag:
		return
	
	var mouse_pos = get_viewport().get_mouse_position()
	var dir = clicked_pos.direction_to(mouse_pos)
	var dist = clicked_pos.distance_to(mouse_pos)
	set_global_position(-dir * dist)


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_MIDDLE:
		
		if Input.is_action_just_pressed("wheel_button"):
			set_drag(true)
			var mouse_pos = get_viewport().get_mouse_position()
			set_clicked_pos(to_global(mouse_pos))
		elif Input.is_action_just_released("wheel_button"):
			set_drag(false)
			set_clicked_pos(Vector2.INF)


#### SIGNAL RESPONSES ####
