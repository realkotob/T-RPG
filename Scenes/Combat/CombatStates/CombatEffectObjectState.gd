extends NestedPushdownAutomata
class_name CombatEffectObjectState

#### ACCESSORS ####

func is_class(value: String): return value == "CombatEffectObjectState" or .is_class(value)
func get_class() -> String: return "CombatEffectObjectState"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("combat_effect_object_chosen", self, "_on_combat_effect_object_chosen")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_combat_effect_object_chosen(obj: CombatEffectObject):
	if !is_current_state():
		return
	
	$TargetChoice.set_combat_effect_obj(obj)
	set_state("TargetChoice")
