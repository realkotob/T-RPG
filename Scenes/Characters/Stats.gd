extends Node

var MaxStats : Resource
var ActualStats : Resource

onready var label = get_node("StatsLabel")
onready var max_label = get_node("MaxStatsLabel")

signal ActualStatsChanged
signal MaxStatsChanged

func _ready():
	# Connect the StatsChanged signal to the label node, so it can display the Stats updated
	var _err = self.connect("ActualStatsChanged", label, "on_Stats_ActualStatsChanged")
	_err = self.connect("MaxStatsChanged", max_label, "on_Stats_MaxStatsChanged")

func initialize(StartingStats : Resource):
	MaxStats = StartingStats
	ActualStats = MaxStats
	emit_signal("ActualStatsChanged", ActualStats)
	emit_signal("MaxStatsChanged", MaxStats)

func get_max_HP():
	return MaxStats.HP

func get_max_MP():
	return MaxStats.MP

func get_max_actions():
	return MaxStats.Actions

func get_max_movements():
	return MaxStats.Movements

func get_acutal_HP():
	return ActualStats.HP

func get_actual_MP():
	return ActualStats.MP

func get_actual_actions():
	return ActualStats.Actions

func get_actual_movements():
	return ActualStats.Movements