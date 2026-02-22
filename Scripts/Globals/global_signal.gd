extends Node

#---------------------------------HUD Signals---------------------------------
#Tooltips
signal show_tooltip(tooltip)
signal near_blackjack(is_near_blackjack: bool)
#Ammo
signal ammo_changed(ammo_changed_by)
signal player_ammo_changed(new_ammo_value)
signal reload(weapon_reloading, ammo_to_reload)
signal reload_finished(ammo_reloaded)
#Money
signal player_money_changed(new_amount)
signal change_money(change_by)

#---------------------------------Interactions---------------------------------
signal play_blackjack()

signal unpause()
