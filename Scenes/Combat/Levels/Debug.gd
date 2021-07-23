extends Node2D


#### ACCESSORS ####



#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("cursor_cell_changed", self, "_on_cursor_cell_changed")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_cursor_cell_changed(_cursor: Cursor, new_cell: Vector3) -> void:
	var actor_cell = owner.active_actor.get_current_cell()
	
	var map = owner.map_node
	var area = IsoRaycast.get_line_of_sight(map, actor_cell, new_cell)
	map.clear_area()
	map.draw_area(area)
