extends Node2D
class_name MovementArrow

const movement_arrow_scene = preload("res://Scenes/MovementArrow/MovementArrowSegment.tscn")

onready var map_node : CombatIsoMap = owner

#### ACCESSORS ####

func is_class(value: String): return value == "MovementArrow" or .is_class(value)
func get_class() -> String: return "MovementArrow"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("generate_movement_arrow", self, "_on_generate_movement_arrow")
	__ = EVENTS.connect("clear_movement_arrow", self, "_on_clear_movement_arrow")

#### VIRTUALS ####



#### LOGIC ####

func clear():
	for child in get_children():
		child.destroy()


func generate(path: PoolVector3Array) -> void:
	var last_segment = null
	var path_size : int = path.size()
	for i in range(path_size):
		var segment = movement_arrow_scene.instance()
		segment.set_current_cell(path[i])
		if i != 0:
			segment.set_previous_segment_dir(get_dir(path[i], path[i - 1]))
		if i != path_size - 1:
			segment.set_next_segment_dir(get_dir(path[i], path[i + 1]))
		call_deferred("add_child", segment)
		last_segment = segment
	
	yield(last_segment, "tree_entered")
	for segment in get_children():
		var cell_pos = map_node.cell_to_world(segment.get_current_cell())
		segment.set_global_position(cell_pos)


# Get the direction of b from a's perspective
func get_dir(a: Vector3, b: Vector3) -> Vector2:
	var a_v2 = Vector2(a.x, a.y)
	var b_v2 = Vector2(b.x, b.y)
	return b_v2 - a_v2


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_generate_movement_arrow(path: PoolVector3Array):
	generate(path)

func _on_clear_movement_arrow():
	clear()
