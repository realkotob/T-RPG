extends IsoEvents
class_name TRPG_Events

# warnings-disable

#### COMBAT EVENTS ####

signal combat_new_turn_started(actor)
signal actor_stats_changed(actor)

signal timeline_movement_finished()

signal update_unabled_actions(move, attack, skill, item, wait)
signal disable_every_actions()

signal actor_action_chosen(action_name)

signal add_action_submenu(data_array)

signal action_choice_menu_entered()
