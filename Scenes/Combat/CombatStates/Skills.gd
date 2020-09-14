extends CombatStateBase

#### COMBAT SKILLS STATE ####

func _ready():
	yield(owner, "ready")
	
	var _err = cursor_node.connect("cell_changed", self, "on_cursor_changed_cell")


# Adapt the cursor color
func on_cursor_changed_cell(cursor_cell : Vector3):
	if get_parent().get_state() != self:
		return
	
	area_node.clear()
	var iso_raycast_node = map_node.get_node("IsoRaycast")
	var line = iso_raycast_node.get_line_of_sight(active_actor.get_current_cell(), cursor_cell)
	area_node.draw_area(line)
