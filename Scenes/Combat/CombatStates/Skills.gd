extends CombatStateBase

#### COMBAT SKILLS STATE ####

#### BUILT-IN ####

func _ready() -> void:
	var __ = EVENTS.connect("skill_chosen", self, "_on_skill_chosen")


#### VIRTUALS ####

func enter_state():
	var skills_array = owner.active_actor.get_skills()
	var option_array : Array = []
	
	for skill in skills_array:
		var option_data_container = OptionDataContainer.new(skill, skill.name, skill.cost, skill.icon)
		option_array.append(option_data_container)
	
	EVENTS.emit_signal("add_action_submenu", option_array, "Skill")


#### SIGNAL RESPONSES ####

func _on_skill_chosen(_skill: Resource):
	#### SEEK A TARGET BEFORE THAT ####
	owner.active_actor.set_state("Skill")
