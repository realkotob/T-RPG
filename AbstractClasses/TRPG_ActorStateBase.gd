extends ActorStateBase
class_name TRPG_ActorStateBase

#### ACCESSORS ####

func is_class(value: String): return value == "TRPG_ActorStateBase" or .is_class(value)
func get_class() -> String: return "TRPG_ActorStateBase"


#### BUILT-IN ####



#### VIRTUALS ####

func enter_state():
	if animated_sprite == null:
		return
	
	var sprite_frames = animated_sprite.get_sprite_frames()
	if sprite_frames == null:
		return
	
	var actor_dir = owner.get_direction()
	var bottom : bool = actor_dir in [Actor.DIRECTION.BOTTOM_LEFT, Actor.DIRECTION.BOTTOM_RIGHT]
	var _right : bool = actor_dir in [Actor.DIRECTION.TOP_RIGHT, Actor.DIRECTION.BOTTOM_RIGHT]
	
	var sufix = "Bottom" if bottom else "Top"
	animated_sprite.play(name + sufix)

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
