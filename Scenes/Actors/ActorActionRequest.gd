extends Object
class_name ActorActionRequest

var func_to_call : FuncRef = null
var arguments : Array = []

#### ACCESSORS ####

func is_class(value: String): return value == "ActorActionRequest" or .is_class(value)
func get_class() -> String: return "ActorActionRequest"


#### BUILT-IN ####

func _init(actor: TRPG_Actor, method_name: String, args: Array = []):
	func_to_call = funcref(actor, method_name)
	arguments = args

#### VIRTUALS ####



#### LOGIC ####

func trigger_action() -> void :
	func_to_call.call_funcv(arguments)


#### INPUTS ####



#### SIGNAL RESPONSES ####
