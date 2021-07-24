extends Position2D

const UPPER_MOVEMENT = Vector2(0, -60)

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
	var _err = tween.interpolate_property(self, "position", position, position + UPPER_MOVEMENT, 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN)


func fade_out_animation() -> void:
	var _err = tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 1.6,
		Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4)
