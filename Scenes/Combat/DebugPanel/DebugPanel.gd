extends CanvasLayer

func _ready():
	var _err = EVENTS.connect("cursor_cell_changed", self, "_on_cursor_changed_cell")
	
	for child in get_children():
		child.set_visible(false)

func _input(_event):
	if Input.is_action_just_pressed("ToggleDebug"):
		for child in get_children():
			child.set_visible(!child.is_visible())


#### SIGNALS REACTION ####

func _on_timeline_state_changed(state: Object):
	$VBoxContainer/TimelineState.text = "Timeline State: " + state.name if state != null else "Timeline State: "

func _on_turn_type_state_changed(state: Object):
	$VBoxContainer/TurnType.text = "Turn Type: " + state.name if state != null else "Turn Type: "
	
func _on_combat_state_changed(state: Object):
	$VBoxContainer/CombatState.text = "Combat State: " + state.name if state != null else "Combat State: "

func _on_combat_substate_changed(state: Object):
	$VBoxContainer/CombatSubState.text = "Combat SubState: " + state.name if state != null else "Combat SubState: "

func _on_cursor_changed_cell(_cursor: Cursor, cell: Vector3):
	$VBoxContainer/CursorPos.text = "Cursor Cell: " + String(cell)

func _on_cursor_max_z_changed(max_z: int):
	$VBoxContainer/CursorMaxZ.text = "Cursor max_z: " + String(max_z)

func _on_active_actor_changed(active_actor: TRPG_Actor):
	$VBoxContainer/ActiveActor.text = "Active TRPG_Actor: " + String(active_actor.name)
	_on_active_actor_pos_changed(active_actor)

func _on_active_actor_state_changed(state: Node):
	var state_name = state.name if state != null else ""
	$VBoxContainer/ActiveActorState.set_text("Active actor state %s " % state_name)

func _on_active_actor_pos_changed(active_actor: TRPG_Actor):
	$VBoxContainer/ActiveActorPos.text = "Active TRPG_Actor's Pos: " + String(active_actor.get_current_cell())
