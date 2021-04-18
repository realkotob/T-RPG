extends IsoEvents
class_name TRPG_Events

# warnings-disable

#### COMBAT EVENTS ####

signal combat_new_turn_started(actor)
signal actor_stats_changed(actor)

signal timeline_movement_finished()

signal skill_chosen(skill)
signal item_chosen(item)

signal target_choice_state_entered()
signal option_choice_state_entered()

signal generate_movement_arrow(path)
signal clear_movement_arrow()

signal actor_action_animation_finished(actor)
signal damage_inflicted(damage_amount, target)

#### ACTION MENU ####

signal disable_actions()
signal update_unabled_actions(move, attack, skill, item, wait)

signal actor_action_chosen(action_name)

signal add_action_submenu(data_array, menu_name)

