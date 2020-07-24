extends Position2D

const UPPER_MOVEMENT = Vector2(0, -60)
const UPSCALE = Vector2(1.2, 1.2)

var damage : int setget set_damage, get_damage

#### ACCESSORS ####

func set_damage(value: int):
	damage = value
	$DamageLabel.set_text(String(damage))

func get_damage() -> int:
	return damage

#### BUILT-IN ####

func _ready():
	var tween_node : Tween = get_node("Tween")
	animate(tween_node)
	yield(tween_node, "tween_all_completed")
	
	queue_free()

#### LOGIC ####

func animate(tween_node: Tween):
	var _err = tween_node.interpolate_property(self, "scale",
		Vector2(1, 1), UPSCALE, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	_err = tween_node.interpolate_property(self, "scale",
		UPSCALE, Vector2(1, 1), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.2)
	
	_err = tween_node.interpolate_property(self, "modulate",
		Color.white, Color.transparent, 2,
		Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4)
	
	_err = tween_node.interpolate_property(self, "position",
		position, position + UPPER_MOVEMENT, 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	_err = tween_node.start()
