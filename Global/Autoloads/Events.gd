extends IsoEvents
class_name TRPG_Events

# warnings-disable

#### COMBAT EVENTS ####

signal combat_new_turn_started(actor)
signal actor_stats_changed(actor)

signal timeline_movement_finished()

signal disable_actions()
signal update_unabled_actions(move, attack, skill, item, wait)

signal actor_action_chosen(action_name)

signal add_action_submenu(data_array, menu_name)

signal action_choice_menu_entered()

signal skill_chosen(skill)
signal item_chosen(item)

signal target_choice_state_entered()
signal option_choice_state_entered()
