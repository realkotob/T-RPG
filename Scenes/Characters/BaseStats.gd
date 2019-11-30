extends Resource

class_name BaseStats

export var HP : int setget HP_set, HP_get
export var MP : int setget MP_set, MP_get
export var Actions : int setget actions_set, actions_get
export var Movements : int setget movements_set, movements_get

func HP_set(value : int):
	HP = max(0, value) as int

func HP_get():
	return HP

func MP_set(value : int):
	MP = max(0, value) as int

func MP_get():
	return MP

func actions_set(value : int):
	Actions = max(0, value) as int

func actions_get():
	return Actions

func movements_set(value : int):
	Movements = max(0, value) as int

func movements_get():
	return Movements