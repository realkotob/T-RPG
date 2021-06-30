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

func clear_arrow():
	for child in get_children():
		child.destroy()


func generate_arrow(path: PoolVector3Array) -> void:
	var last_segment = null
	
	for i in range(path.size()):
		var segment = movement_arrow_scene.instance()
		segment.set_current_cell(path[i])
		if i != 0:
			segment.set_previous_segment_dir(get_dir(path[i], path[i - 1]))
		if i != path.size() - 1:
			segment.set_next_segment_dir(get_dir(path[i], path[i + 1]))
		call_deferred("add_child", segment)
		last_segment = segment
	
	yield(last_segment, "tree_entered")
	
	for segment in get_children():
		var cell_pos = map_node.cell_to_world(segment.get_current_cell())
		segment.set_global_position(cell_pos)


func update_arrow(path: PoolVector3Array) -> void:
	var segment_array = get_children()
	var reused_segments = []
	
	for i in range(path.size()):
		var cell = path[i]
		var previous_dir = get_dir(cell, path[i - 1]) if i != 0 else Vector2.INF
		var next_dir = get_dir(cell, path[i + 1]) if i != path.size() - 1 else Vector2.INF
		var reuse_seg : bool = false
		
		# Reuse existing segments
		for segment in segment_array:
			if cell == segment.get_current_cell():
				segment.change_segment_dir(previous_dir, next_dir)
				reused_segments.append(segment)
				reuse_seg = true
		
		# Create new segment if necesary
		if !reuse_seg:
			var segment = movement_arrow_scene.instance()
			segment.set_current_cell(cell)
			segment.set_previous_segment_dir(previous_dir)
			segment.set_next_segment_dir(next_dir)
			call_deferred("add_child", segment)
			
			var cell_pos = map_node.cell_to_world(segment.get_current_cell())
			segment.set_global_position(cell_pos)
	
	# Delete segment that aren't usefull
	for segment in segment_array:
		if not segment in reused_segments:
			segment.destroy()

# Get the direction of b from a's perspective
func get_dir(a: Vector3, b: Vector3) -> Vector2:
	var a_v2 = Vector2(a.x, a.y)
	var b_v2 = Vector2(b.x, b.y)
	return b_v2 - a_v2


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_generate_movement_arrow(path: PoolVector3Array):
	clear_arrow()
	generate_arrow(path)


func _on_clear_movement_arrow():
	clear_arrow()
