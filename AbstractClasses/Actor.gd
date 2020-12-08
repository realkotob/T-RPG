extends DamagableObject
class_name Actor

onready var states_node = $States
onready var move_node = $States/Move

var area_node : TileMap
var timeline_port_node : Node
var active : bool = false

export var portrait : Texture
export var timeline_port : Texture
export var MaxStats : Resource

export var weapon : Resource setget set_weapon, get_weapon

var current_actions : int = 0 setget set_current_actions, get_current_actions
var current_movements : int = 0 setget set_current_movements, get_current_movements
var current_MP : int = 0 setget set_current_MP, get_current_MP

var default_range : int = 1 setget set_default_range, get_default_range
var current_range : int = 1 setget set_current_range, get_current_range

var action_modifier : int = 0 setget set_action_modifier, get_action_modifier
var jump_max_height : int = 2 setget set_jump_max_height, get_jump_max_height

var move_speed : float = 300

signal action_spent

#### BUILT-IN FUNCTIONS ####

# Add the node to the group allies
func _init():
	add_to_group("Actors")


# Set the current stats to the starting stats
func _ready():
	var combat_node = get_tree().get_current_scene()
	var _err = connect("action_spent", combat_node, "on_action_spent")
	
	set_current_actions(get_max_actions())
	set_current_movements(get_max_movements())
	set_current_HP(get_max_HP())
	set_current_MP(get_max_MP())
	set_current_range(get_default_range())


### ACCESORS ###

func set_active(value: bool):
	active = value
	if active:
		turn_start()
	else:
		turn_finish()

func get_max_HP(): return MaxStats.get_HP()
func get_max_MP(): return MaxStats.get_MP()

func get_max_actions(): return MaxStats.get_actions()
func get_max_movements(): return MaxStats.get_movements()

func get_current_HP(): return current_HP
func set_current_HP(value : int): current_HP = value

func get_current_MP(): return current_MP
func set_current_MP(value: int): current_MP = value

func set_default_range(value: int): default_range = value
func get_default_range() -> int: return default_range

func set_current_range(value: int): current_range = value
func get_current_range() -> int: return current_range

func set_current_actions(value : int):
	var callback : bool = value < current_actions
	current_actions = value
	if callback:
		emit_signal("action_spent")

func get_current_actions(): return current_actions

func get_current_movements(): return current_movements

func set_current_movements(value : int): current_movements = value

func set_state(value : String): states_node.set_state(value)
func get_state() -> Object: return states_node.get_state()
func get_state_name() -> String: return states_node.get_state_name()

func set_jump_max_height(value : int): jump_max_height = value
func get_jump_max_height() -> int: return jump_max_height

func set_action_modifier(value: int): action_modifier = value
func get_action_modifier() -> int: return action_modifier

func set_weapon(value: Weapon): weapon = value
func get_weapon() -> Resource: return weapon

func get_defense() -> int: return MaxStats.get_defense()

#### CALLBACKS ####

func turn_start():
	set_current_actions(get_max_actions() + action_modifier)
	action_modifier = 0

func turn_finish():
	pass

#### LOGIC ####

func decrement_current_action(amount : int = 1):
	set_current_actions(get_current_actions() - amount)


func move_to(delta: float, world_pos: Vector2) -> bool:
	set_state("Move")
	return $States/Move.move_to(delta, world_pos)

func hurt(damage: int):
	set_current_HP(get_current_HP() - damage)
	set_state("Hurt")

# Return the altitude of the current cell of the character
func get_height() -> int:
	return int(current_cell.z)
