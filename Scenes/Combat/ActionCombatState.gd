extends StateBase
class_name ActionCombatState

var aoe_target : AOE_Target = null setget set_aoe_target, get_aoe_target
var target_array = []

var timeline_resise_needed : bool = false 

var action_anim_finished : bool = false
var action_consequence_finished : bool = false

signal action_feedback_finished

#### ACCESSORS ####

func is_class(value: String): return value == "AnimationCombatState" or .is_class(value)
func get_class() -> String: return "AnimationCombatState"

func set_aoe_target(value: AOE_Target): aoe_target = value
func get_aoe_target() -> AOE_Target: return aoe_target

#### BUILT-IN ####


func _ready() -> void:
	var __ = EVENTS.connect("timeline_resize_finished", self, "_on_timeline_resize_finished")
	__ = EVENTS.connect("actor_died", self, "_on_actor_died")
	__ = connect("action_feedback_finished", self, "_on_action_feedback_finished")


#### VIRTUALS ####

func enter_state() -> void:
	var map = owner.map_node
	target_array = map.get_damagable_in_area(aoe_target)
	var actor = owner.active_actor
	
	var __ = actor.connect("action_finished", self, "_on_active_actor_action_finished")
	
	for target in target_array:
		__ = target.connect("action_consequence_finished", self, "_on_action_consequence_finished", [target])


func exit_state() -> void:
	for target in target_array:
		target.disconnect("action_consequence_finished", self, "_on_action_consequence_finished")
	
	var actor = owner.active_actor
	if actor.is_connected("action_finished", self, "_on_active_actor_action_finished"):
		owner.active_actor.disconnect("action_finished", self, "_on_active_actor_action_finished")
	
	aoe_target = null
	target_array = []
	timeline_resise_needed = false
	action_anim_finished = false
	action_consequence_finished = false


#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_active_actor_action_finished(previous_state_name: String) -> void:
	if previous_state_name in ["Attack", "Action"]:
		action_anim_finished = true
		owner.active_actor.disconnect("action_finished", self, "_on_active_actor_action_finished")
		
		if action_consequence_finished:
			emit_signal("action_feedback_finished")


func _on_action_consequence_finished(target: TRPG_DamagableObject) -> void:
	action_consequence_finished = true
	
	if target in target_array:
		if target.is_connected("action_consequence_finished", self, "_on_action_consequence_finished"):
			target.disconnect("action_consequence_finished", self, "_on_action_consequence_finished")
		target_array.erase(target)
	
	if action_anim_finished:
		emit_signal("action_feedback_finished")


func _on_action_feedback_finished() -> void:
	
	if timeline_resise_needed:
		yield(EVENTS, "timeline_resize_finished")
	
	EVENTS.emit_signal("action_phase_finished")


func _on_actor_died(actor: TRPG_Actor) -> void:
	if is_current_state() && actor in target_array:
		timeline_resise_needed = true


func _on_timeline_resize_finished() -> void:
	timeline_resise_needed = false
