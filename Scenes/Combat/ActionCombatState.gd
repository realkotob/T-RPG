extends StateBase
class_name ActionCombatState

var aoe_target : AOE_Target = null
var target_array = []

#### ACCESSORS ####

func is_class(value: String): return value == "AnimationCombatState" or .is_class(value)
func get_class() -> String: return "AnimationCombatState"


#### BUILT-IN ####



#### VIRTUALS ####

func enter_state():
	var map = owner.map_node
	target_array = map.get_damagable_in_area(aoe_target)
	
	for target in target_array:
		var __ = target.connect("action_consequence_finished", self, 
					"_on_action_consequence_finished", [target], CONNECT_ONESHOT)


func exit_state():
	aoe_target = null
	target_array = []

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_action_consequence_finished(target: TRPG_DamagableObject) -> void:
	if target in target_array:
		target_array.erase(target)
	
	if target_array.empty():
		EVENTS.emit_signal("action_phase_finished")
