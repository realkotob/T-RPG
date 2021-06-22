extends StateBase
class_name ActionCombatState

var aoe_target : AOE_Target = null setget set_aoe_target, get_aoe_target
var target_array = []

var timeline_resise_needed : bool = false 

#### ACCESSORS ####

func is_class(value: String): return value == "AnimationCombatState" or .is_class(value)
func get_class() -> String: return "AnimationCombatState"

func set_aoe_target(value: AOE_Target): aoe_target = value
func get_aoe_target() -> AOE_Target: return aoe_target

#### BUILT-IN ####


func _ready() -> void:
	var __ = EVENTS.connect("timeline_resize_finished", self, "_on_timeline_resize_finished")
	__ = EVENTS.connect("actor_died", self, "_on_actor_died")


#### VIRTUALS ####

func enter_state() -> void:
	var map = owner.map_node
	target_array = map.get_damagable_in_area(aoe_target)
	
	for target in target_array:
		var __ = target.connect("action_consequence_finished", self, 
					"_on_action_consequence_finished", [target], CONNECT_ONESHOT)


func exit_state() -> void:
	aoe_target = null
	target_array = []
	timeline_resise_needed = false


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_action_consequence_finished(target: TRPG_DamagableObject) -> void:
	if target in target_array:
		target_array.erase(target)
	
	if target_array.empty() && !timeline_resise_needed:
		EVENTS.emit_signal("action_phase_finished")


func _on_actor_died(actor: TRPG_Actor) -> void:
	if is_current_state() && actor in target_array:
		timeline_resise_needed = true


func _on_timeline_resize_finished() -> void:
	if !is_current_state():
		return
	
	timeline_resise_needed = false
	
	if target_array.empty():
		EVENTS.emit_signal("action_phase_finished")
