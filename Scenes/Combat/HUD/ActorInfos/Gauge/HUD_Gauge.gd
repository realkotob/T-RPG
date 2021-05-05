extends Gauge
class_name HUD_Gauge

onready var refill_sound : AudioStreamPlayer = $RefillSound

#### ACCESSORS ####

func is_class(value: String): return value == "HUD_Gauge" or .is_class(value)
func get_class() -> String: return "HUD_Gauge"


#### BUILT-IN ####



#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
