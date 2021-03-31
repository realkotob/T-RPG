extends StatesMachine
class_name CombatStateMachine

signal substate_changed(state_name)

#### ACCESSORS ####

func is_class(value: String): return value == "CombatStateMachine" or .is_class(value)
func get_class() -> String: return "CombatStateMachine"


#### BUILT-IN ####


func _ready() -> void:
	for child in get_children():
		if child.has_signal("state_changed"):
			var __ = child.connect("state_changed", self, "_on_substate_changed")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_substate_changed(state_name: String):
	emit_signal("substate_changed", state_name)
