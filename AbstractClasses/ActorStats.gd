extends Resource
class_name ActorStats

export var HP : int setget set_HP, get_HP
export var MP : int setget set_MP, get_MP
export var actions : int setget set_actions, get_actions
export var movements : int setget set_movements, get_movements
export var attack_range : int setget set_attack_range, get_attack_range
export var defense : int setget set_defense, get_defense
export var view_range : int setget set_view_range, get_view_range

func set_HP(value : int): HP = max(0, value) as int
func get_HP() -> int: return HP

func set_MP(value : int): MP = max(0, value) as int
func get_MP() -> int: return MP

func set_actions(value : int): actions = max(0, value) as int
func get_actions() -> int: return actions

func set_movements(value : int): movements = max(0, value) as int
func get_movements() -> int: return movements

func set_attack_range(value: int): attack_range = value
func get_attack_range() -> int: return attack_range

func set_defense(value: int): defense = value
func get_defense() -> int: return defense

func set_view_range(value: int): view_range = value
func get_view_range() -> int: return view_range
