extends CanvasLayer

enum Shop_State { START, BUY, SELL}

var current_state = Shop_State.START
var last_state = current_state
var shop_stock = []
var item_cards = []
var stock_refreshed = false
@onready var buy_or_sell: Control = $"Buy Or Sell"
@onready var buy_menu: Control = $"Buy Menu"
@onready var sell_menu: Control = $"Sell Menu"
@onready var stock_box: VBoxContainer = $"Buy Menu/ScrollContainer/VBoxContainer"

func _ready() -> void:
	# EXAMPLES
	var item_scene = preload("res://item.gd")
	
	
	var ammo_item = item_scene.create("Revolver Ammo", "Bullets for your revolver.", 0.05, 0, false)
	var whiskey = item_scene.create("Bush Whiskey", "The finest and oldest whiskey in the west, imported from Co. Antrim.\n\nPrevents your stamina bar from depleting for 20 seconds.", 1, 0.2, false)
	shop_stock.append([ammo_item, 100, 1])
	shop_stock.append([whiskey, 5, 2])
	
func _process(delta: float) -> void:
	
	match current_state:
		Shop_State.START:
			start_screen()
		Shop_State.BUY:
			buy_screen()
		Shop_State.SELL:
			sell_screen()
			
func start_screen():
	buy_or_sell.visible = true

func buy_screen():
	buy_menu.visible = true
	if not stock_refreshed:
		draw_stock()
		stock_refreshed = true

func sell_screen():
	sell_menu.visible = true
	
func change_state(state):
	last_state = current_state
	current_state = state

func set_stock(stock):
	shop_stock = stock
	
func draw_stock():
	for item in shop_stock:
		var item_card = Shop_Item.new()
		item_card.create(item, item[1])
		item_cards.append(item_card)
		stock_box.add_child(item_card)
		
func _on_enter_buy_pressed() -> void:
	change_state(Shop_State.BUY)
	buy_or_sell.visible = false

func _on_enter_sell_pressed() -> void:
	change_state(Shop_State.SELL)
	buy_or_sell.visible = false

func _on_back_from_buy_pressed() -> void:
	change_state(Shop_State.START)
	buy_menu.visible = false

func _on_back_from_sell_pressed() -> void:
	change_state(Shop_State.START)
	sell_menu.visible = false
