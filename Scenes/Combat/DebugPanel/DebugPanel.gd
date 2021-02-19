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

func _on_timeline_state_changed(state_name):
	$VBoxContainer/TimelineState.text = "Timeline State: " + state_name

func _on_combat_state_changed(state_name: String):
	$VBoxContainer/CombatState.text = "Combat State: " + state_name

func _on_cursor_changed_cell(_cursor: Cursor, cell: Vector3):
	$VBoxContainer/CursorPos.text = "Cursor Cell: " + String(cell)

func _on_cursor_max_z_changed(max_z: int):
	$VBoxContainer/CursorMaxZ.text = "Cursor max_z: " + String(max_z)

func _on_active_actor_changed(active_actor: Actor):
	$VBoxContainer/ActiveActor.text = "Active Actor: " + String(active_actor.name)
	_on_active_actor_pos_changed(active_actor)

func _on_active_actor_pos_changed(active_actor: Actor):
	$VBoxContainer/ActiveActorPos.text = "Active Actor's Pos: " + String(active_actor.get_current_cell())
