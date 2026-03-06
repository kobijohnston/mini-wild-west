extends Node

#---------------------------------HUD Signals---------------------------------
#Tooltips
signal show_tooltip(tooltip)
signal near_blackjack(is_near_blackjack: bool)
signal near_shop_desk(shop, is_near_shop: bool)
#Ammo
signal change_ammo(change_by) # Used for buying or selling ammo
signal ammo_changed(ammo_changed_by) # Used for revolver barrell UI 
signal player_ammo_changed(new_ammo_value)
signal reload(weapon_reloading, ammo_to_reload)
signal reload_finished(ammo_reloaded)
#Money
signal player_money_changed(new_amount)
signal change_money(change_by)
#Stamina
signal is_player_sprinting(is_sprinting: bool, current_stamina)
#Inventory
signal give_item(item)
signal take_item(item)

#Shop
signal item_selected(selected_item)

#---------------------------------Interactions---------------------------------
signal play_blackjack()

signal unpause()
