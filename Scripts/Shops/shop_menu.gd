extends CanvasLayer

enum Shop_State { START, BUY, SELL}

var current_state = Shop_State.START
var last_state = current_state
var shop_stock = []
var item_cards = []
var stock_refreshed = false
var selected_item
var player
@onready var buy_or_sell: Control = $"Buy Or Sell"
@onready var buy_menu: Control = $"Buy Menu"
@onready var sell_menu: Control = $"Sell Menu"
@onready var buy_vbox: VBoxContainer = $"Buy Menu/ScrollContainer/VBoxContainer"
@onready var buy_item: Control = $"Buy Menu/Buy Item"
@onready var item_description: RichTextLabel = $"Buy Menu/Buy Item/Item Description"

@onready var shop_item_scene = preload("res://Scenes/Menus/shop_item.tscn")
func _ready() -> void:
	# EXAMPLES
	
	GlobalSignal.item_selected.connect(_on_item_selected)
	
	var ammo_item = Item.new().create("Revolver Ammo", "Bullets for your revolver.", 0.05, GlobalEnums.Item_Type.AMMO, 1, false, false, "false")
	var whiskey = Item.new().create("Bush Whiskey", "Imported from Co. Antrim.\n\nPrevents your stamina bar from depleting for 20 seconds.", 1, GlobalEnums.Item_Type.STAMINA, 300, false, false, "whiskey.png")
	var shotgun = Item.new().create("Pump-Action Shotgun", "Wipe out hordes of enemies with this crowd-controlling menace.", 5, GlobalEnums.Item_Type.BASE, 1, true, true, "false")
	
	shop_stock.append([ammo_item, 10, 1])
	shop_stock.append([whiskey, 5, 2])
	shop_stock.append([shotgun, 1, 3])
	
func _process(delta: float) -> void:
	
	match current_state:
		Shop_State.START:
			start_screen()
		Shop_State.BUY:
			buy_screen()
		Shop_State.SELL:
			sell_screen()
			
func configure(p):
	player = p

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

func _on_back_from_buy_pressed() -> void:
	change_state(Shop_State.START)
	buy_menu.visible = false

func _on_item_selected(shop_item):
	buy_item.visible = true
	item_description.text = shop_item.item["description"]
	selected_item = shop_item

func _on_buy_button_pressed() -> void:
	
	if player["money"] >= selected_item.item["price"] and selected_item.shop_item["quantity"] > 0:
		selected_item.update_quantity(-1)
		GlobalSignal.change_money.emit(-selected_item.item["price"])
		if selected_item.item["type"] == GlobalEnums.Item_Type.AMMO:
			GlobalSignal.change_ammo.emit(selected_item.item["modifier"])
		else:
			var i = Item.new()
			GlobalSignal.give_item.emit(i.copy(selected_item.item))
			
func _on_back_from_sell_pressed() -> void:
	change_state(Shop_State.START)
	sell_menu.visible = false

func _on_enter_sell_pressed() -> void:
	change_state(Shop_State.SELL)
	buy_or_sell.visible = false

func _on_quit_pressed() -> void:
	GlobalSignal.unpause.emit()
	queue_free()
