extends CombatStateBase

#### COMBAT SKILLS STATE ####


func enter_state():
	var skills_array = owner.active_actor.get_skills()
	var option_array : Array = []
	
	for skill in skills_array:
		var option_data_container = OptionDataContainer.new(skill.skill_name, skill.cost, skill.icon_texture)
		option_array.append(option_data_container)
	
	EVENTS.emit_signal("add_action_submenu", option_array, "Skill")
