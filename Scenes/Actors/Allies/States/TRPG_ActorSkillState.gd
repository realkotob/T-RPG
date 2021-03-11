extends TRPG_ActorStateBase
class_name TRPG_ActorSkillState

#### ACCESSORS ####

func is_class(value: String): return value == "TRPG_ActorSkillState" or .is_class(value)
func get_class() -> String: return "TRPG_ActorSkillState"


#### BUILT-IN ####

func _ready() -> void:
	yield(owner, "ready")
	
	var anim_player = owner.animation_player_node
	if anim_player != null:
		var __ = anim_player.connect("animation_finished", self, "_on_animation_player_animation_finished")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == name:
		owner.set_state("Idle")
