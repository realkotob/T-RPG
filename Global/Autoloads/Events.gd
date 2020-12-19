extends Node

# warnings-disable

#### MAP EVENTS ####

signal cursor_cell_changed(cursor)
signal visible_cells_changed()

#### COMBAT EVENTS ####

signal combat_new_turn_started(actor)
signal active_actor_stats_changed(actor)
