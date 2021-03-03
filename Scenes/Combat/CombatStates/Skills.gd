extends CombatStateBase

#### COMBAT SKILLS STATE ####

func _ready():
	yield(owner, "ready")
	
	var _err = EVENTS.connect("cursor_cell_changed", self, "on_cursor_changed_cell")


# Adapt the cursor color
func on_cursor_changed_cell(_cursor: Cursor, cursor_cell: Vector3):
	if get_parent().get_state() != self:
		return
	
	combat_loop.area_node.clear()
	var actor_cell = combat_loop.active_actor.get_current_cell()
	
	var line = IsoRaycast.get_line(combat_loop.map_node, actor_cell, cursor_cell)
	combat_loop.area_node.draw_area(line, "view")


func enter_state():
	EVENTS.emit_signal("add_action_submenu", ["POUET", "PROUT", "SUBBARATH"], name)
