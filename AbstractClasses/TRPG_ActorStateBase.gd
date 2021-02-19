extends ActorStateBase
class_name TRPG_ActorStateBase

#### ACCESSORS ####

func is_class(value: String): return value == "TRPG_ActorStateBase" or .is_class(value)
func get_class() -> String: return "TRPG_ActorStateBase"


#### BUILT-IN ####

func _ready() -> void:
	var __ = owner.connect("changed_direction", self, "_on_actor_changed_direction")

#### VIRTUALS ####

func enter_state():
	update_actor_animation(owner.get_direction())


#### LOGIC ####

func update_actor_animation(actor_dir: int):
	if animated_sprite == null:
		return
	
	var sprite_frames = animated_sprite.get_sprite_frames()
	if sprite_frames == null:
		return

	var bottom : bool = actor_dir in [Actor.DIRECTION.BOTTOM_LEFT, Actor.DIRECTION.BOTTOM_RIGHT]
	var right : bool = actor_dir in [Actor.DIRECTION.TOP_RIGHT, Actor.DIRECTION.BOTTOM_RIGHT]
	
	var sufix = "Bottom" if bottom else "Top"
	var animation_name = name + sufix
	if sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)
	
	animated_sprite.set_flip_h(!right)


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_actor_changed_direction(dir: int):
	if states_machine.get_state() != self:
		 return
	
	update_actor_animation(dir)
