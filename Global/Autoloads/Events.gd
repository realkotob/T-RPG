extends IsoEvents
class_name TRPG_Events

# warnings-disable

#### COMBAT EVENTS ####

signal turn_finished()
signal actor_died(actor)

signal combat_new_turn_started(actor)
signal actor_stats_changed(actor)

signal timeline_movement_finished()
signal timeline_resize_finished()

signal area_added(map)
signal area_cell_removed(tilemap, cell)
signal area_cleared(map)

signal combat_effect_object_chosen(obj)

signal target_choice_state_entered()
signal option_choice_state_entered()

signal generate_movement_arrow(path)
signal clear_movement_arrow()

signal damagable_targeted(damagable)

signal active_actor_turn_started(actor)
signal active_actor_turn_finished(actor)
signal IA_overlook_begun(actor)

signal actor_action_finished(actor)
signal actor_action_animation_finished(actor)
signal actor_cell_changed(actor, from, to)
signal damage_inflicted(damage_amount, target, critical)

#### ACTION MENU ####

signal disable_actions()
signal update_unabled_actions(move, attack, skill, item, wait)

signal actor_action_chosen(action_name)

signal add_action_submenu(data_array, menu_name)

