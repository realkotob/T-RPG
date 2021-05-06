extends CombatEffectObjectState

#### COMBAT ITEMS STATE ####

func enter_state():
	var item_array = owner.active_actor.get_team().get_inventory()
	var option_array : Array = []
	
	for item_couple in item_array:
		var item = item_couple[0]
		var amount = item_couple[1]
		var option_data_container = OptionDataContainer.new(item, item.name, amount, item.icon)
		option_array.append(option_data_container)
	
	EVENTS.emit_signal("add_action_submenu", option_array, "Item")
	
	set_state("OptionChoice")
