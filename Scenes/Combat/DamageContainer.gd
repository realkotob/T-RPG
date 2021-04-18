extends Node2D
class_name DamageContainer

const DAMAGE_LABEL_SCENE := preload("res://Scenes/Combat/DamageLabel/DamageLabel.tscn")

#### ACCESSORS ####

func is_class(value: String): return value == "DamageContainer" or .is_class(value)
func get_class() -> String: return "DamageContainer"


#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("damage_inflicted", self, "instance_damage_label")


#### VIRTUALS ####



#### LOGIC ####

# Instanciate a damage label with the given amount on top of the given target
func instance_damage_label(damage: int, target: TRPG_DamagableObject):
	var damage_label = DAMAGE_LABEL_SCENE.instance()
	damage_label.set_global_position(target.get_global_position())
	damage_label.set_damage(damage)
	
	call_deferred("add_child", damage_label)


#### INPUTS ####



#### SIGNAL RESPONSES ####
