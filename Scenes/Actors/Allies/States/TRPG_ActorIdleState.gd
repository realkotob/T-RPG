extends TRPG_ActorStateBase
class_name TRPG_ActorIdleState

var idle_anim_count : int = 0

#### ACCESSORS ####

func is_class(value: String): return value == "TRPG_ActorIdleState" or .is_class(value)
func get_class() -> String: return "TRPG_ActorIdleState"


#### BUILT-IN ####



#### VIRTUALS ####

func enter_state() -> void:
	.enter_state()
	
	var __ = animated_sprite.connect("animation_finished", self, "_on_idle_animation_finished")
	
	_update_idle_anim_variation()


func exit_state() -> void:
	if animated_sprite.is_connected("animation_finished", self, "_on_idle_animation_finished"):
		animated_sprite.disconnect("animation_finished", self, "_on_idle_animation_finished")


#### LOGIC ####

func _update_idle_anim_variation() -> void:
	var anim_name = _get_animation_name()
	var is_static_anim = animated_sprite.get_sprite_frames().get_frame_count(anim_name) == 1
	
	if is_static_anim:
		var delay = rand_range(3.0, 5.0)
		yield(get_tree().create_timer(delay), "timeout")
		_play_variation_animation()
	else:
		idle_anim_count = Math.randi_range(3, 5)
		_play_variation_animation()


func _play_variation_animation() -> void:
	var variations = _get_anim_variations()
	if variations.empty():
		return
	
	var rdm_id = randi() % variations.size()
	
	animated_sprite.play(variations[rdm_id])


func _get_anim_variations() -> PoolStringArray:
	var anim_name = _get_animation_name()
	var variations_array = PoolStringArray()
	var anim_names_array = animated_sprite.get_sprite_frames().get_animation_names()
	
	for anim in anim_names_array:
		if anim_name.is_subsequence_ofi(anim) && anim != anim_name:
			variations_array.append(anim)
	
	return variations_array


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_idle_animation_finished() -> void:
	if !is_current_state(): return
	
	var anim_name = _get_animation_name()
	var is_static_anim = animated_sprite.get_sprite_frames().get_frame_count(anim_name) == 1

	var is_main_anim = animated_sprite.get_animation() == _get_animation_name()
	
	if is_main_anim:
		if !is_static_anim:
			idle_anim_count -= 1
			if idle_anim_count == 0:
				_update_idle_anim_variation()
	else:
		animated_sprite.play(anim_name)
		_update_idle_anim_variation()
