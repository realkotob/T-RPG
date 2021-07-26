extends Position2D

const UPPER_MOVEMENT = -40
const LATERAL_MOVEMENT = 20
const ANIMATION_DUR = 1.0
const FADE_DELAY = 0.4

onready var tween = $Tween

var combat_damage : CombatDamage = null

#### ACCESSORS ####

func set_combat_damage(value: CombatDamage):
	combat_damage = value
	$DamageLabel.set_text(String(combat_damage.damage))

func get_combat_damage() -> CombatDamage: return combat_damage


#### BUILT-IN ####

func _ready():
	animate()
	yield(tween, "tween_all_completed")
	
	queue_free()


#### LOGIC ####

func animate():
	var damage_scale = combat_damage.get_damage_scale()
	
	grow_animation(damage_scale)
	rotate_animation()
	movement_animation()
	fade_out_animation()
	
	var _err = tween.start()


func grow_animation(damage_scale: int) -> void:
	var upscale = 1.2
	match(damage_scale):
		CombatDamage.DAMAGE_SCALE.HIGH: upscale = 1.5
		CombatDamage.DAMAGE_SCALE.SEVERE: upscale = 2
	
	var _err = tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2.ONE * upscale, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	_err = tween.interpolate_property(self, "scale", Vector2.ONE * upscale, Vector2(1, 1), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.2)


func movement_animation() -> void:
	var movement = UPPER_MOVEMENT + UPPER_MOVEMENT * rand_range(0, 0.3) * Math.rand_sign()
	
	var _err = tween.interpolate_property(self, "position:y", position.y, 
		position.y + movement, ANIMATION_DUR,
		Tween.TRANS_BACK, Tween.EASE_OUT)


func fade_out_animation() -> void:
	var _err = tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 
		ANIMATION_DUR - FADE_DELAY, Tween.TRANS_CUBIC, Tween.EASE_OUT, FADE_DELAY)


func rotate_animation() -> void:
	var rdm_angle = deg2rad(rand_range(15, 25) * Math.rand_sign())
	var dir = Vector2.UP.rotated(rdm_angle * 3)
	var lateral_movement = LATERAL_MOVEMENT + LATERAL_MOVEMENT * rand_range(0, 0.3) * Math.rand_sign()
	
	var _err = tween.interpolate_property(self, "position:x", position.x, 
		(position + dir * lateral_movement).x, ANIMATION_DUR, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	_err = tween.interpolate_property(self, "rotation", rotation, rotation + rdm_angle,
		ANIMATION_DUR, Tween.TRANS_LINEAR, Tween.EASE_OUT)
