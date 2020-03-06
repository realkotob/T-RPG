extends Control

onready var action_buttons_array = $ActionMenu.get_children()

var combat_state_node: Node

func setup():
	for button in action_buttons_array:
		if "combat_state_node" in button:
			button.combat_state_node = combat_state_node
		
		if button.has_method("setup"):
			button.setup()
