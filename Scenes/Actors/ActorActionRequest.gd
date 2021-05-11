extends Object
class_name ActorActionRequest

var func_to_call : FuncRef = null
var method_name : String = ""
var actor : TRPG_Actor = null
var arguments : Array = []

#### ACCESSORS ####

func is_class(value: String): return value == "ActorActionRequest" or .is_class(value)
func get_class() -> String: return "ActorActionRequest"


#### BUILT-IN ####

func _init(_actor: TRPG_Actor, _method_name: String, args: Array = []):
	actor = _actor
	method_name = _method_name
	func_to_call = funcref(actor, method_name)
	arguments = args

#### VIRTUALS ####



#### LOGIC ####

func trigger_action() -> void :
	func_to_call.call_funcv(arguments)

func get_method_name() -> String:
	if func_to_call == null:
		return ""
	else:
		return method_name

#### INPUTS ####



#### SIGNAL RESPONSES ####
