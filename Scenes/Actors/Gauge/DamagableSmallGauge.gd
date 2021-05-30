extends Gauge
class_name DamagableSmallGauge

onready var damagable = get_parent()

#### ACCESSORS ####

func is_class(value: String): return value == "ActorSmallGauge" or .is_class(value)
func get_class() -> String: return "ActorSmallGauge"


#### BUILT-IN ####

func _ready() -> void:
	var __ = damagable.connect("hp_changed", self, "_on_damagable_hp_changed")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_damagable_hp_changed(current_hp: int, max_hp: int) -> void:
	set_gauge_max_value(max_hp)
	set_gauge_value(current_hp)
