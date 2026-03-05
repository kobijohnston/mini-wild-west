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
@onready var buy_vbox: VBoxContainer = $"Buy Menu/ScrollContainer/VBoxContainer"

@onready var shop_item_scene = preload("res://Scenes/Menus/shop_item.tscn")
func _ready() -> void:
	# EXAMPLES
	var ammo_item = Item.new().create("Revolver Ammo", "Bullets for your revolver.", 0.05, GlobalEnums.Item_Type.BASE, 1, false, false, false)
	var whiskey = Item.new().create("Bush Whiskey", "Imported from Co. Antrim.\n\nPrevents your stamina bar from depleting for 20 seconds.", 1, GlobalEnums.Item_Type.STAMINA, 300, false, false, false)
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
		var shop_item = shop_item_scene.instantiate()
		buy_vbox.add_child(shop_item)
		shop_item.config(item[0], item[1])
		
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
