extends Node

signal show_tooltip(tooltip)
signal ammo_changed(ammo_changed_by)
signal player_ammo_changed(new_ammo_value)
signal reload(weapon_reloading, ammo_to_reload)
signal reload_finished(ammo_reloaded)
signal near_blackjack(is_near_blackjack: bool)
signal play_blackjack()
signal unpause()
