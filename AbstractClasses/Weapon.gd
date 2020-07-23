extends Resource
class_name Weapon

export var attack : int = 1 setget set_attack, get_attack
export var attack_range : int = 1 setget set_attack_range, get_attack_range

enum RANGE_TYPES {
	CIRCLE
	LINE,
	SQUARE
}

export var range_type : int = RANGE_TYPES.CIRCLE

#### ACCESSORS ####

func set_attack(value: int):
	attack = value

func get_attack() -> int:
	return attack

func set_attack_range(value: int):
	attack_range = value

func get_attack_range() -> int:
	return attack_range

#### BUILT-IN ####

func _ready():
	pass
