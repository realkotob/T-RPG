extends CombatStateBase

#### COMBAT SKILLS STATE ####

func _ready():
	yield(owner, "ready")
	
	var _err = Events.connect("cursor_cell_changed", self, "on_cursor_changed_cell")


# Adapt the cursor color
func on_cursor_changed_cell(cursor: Cursor):
	if get_parent().get_state() != self:
		return
	
	var cursor_cell = cursor.get_current_cell()
	owner.area_node.clear()
	var iso_raycast_node = owner.map_node.get_node("IsoRaycast")
	var actor_cell = owner.active_actor.get_current_cell()
	var line = iso_raycast_node.get_line_of_sight(actor_cell, cursor_cell)
	owner.area_node.draw_area(line)
