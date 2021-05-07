extends NestedPushdownAutomata
class_name CombatEffectObjectState

var combat_effect_obj : CombatEffectObject = null

#### ACCESSORS ####

func is_class(value: String): return value == "CombatEffectObjectState" or .is_class(value)
func get_class() -> String: return "CombatEffectObjectState"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("combat_effect_object_chosen", self, "_on_combat_effect_object_chosen")
	__ = $TargetChoice.connect("target_chosen", self, "_on_target_chosen")

#### VIRTUALS ####

func exit_state():
	combat_effect_obj = null


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_combat_effect_object_chosen(obj: CombatEffectObject):
	if !is_current_state():
		return
	
	combat_effect_obj = obj
	$TargetChoice.set_aoe(combat_effect_obj.aoe)
	$TargetChoice.positive = combat_effect_obj.possitive
	set_state("TargetChoice")


func _on_target_chosen(aoe_target: AOE_Target):
	if combat_effect_obj is Item:
		owner.active_actor.use_item(combat_effect_obj, aoe_target)
	elif combat_effect_obj is Skill:
		owner.active_actor.use_skill(combat_effect_obj, aoe_target)

