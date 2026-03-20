extends Control

# Requires GlobalFuncs.format_as_money(money) @ line 35

var shop_item = {
	"name": "",
	"price": 0,
	"quantity": 0,
	"description": ""
}

var item

var hovering = false

var SELL_MODIFIER = 0.4
@onready var item_name: Label = $"Item Name"
@onready var price: Label = $Price
@onready var background: ColorRect = $ColorRect
@onready var stock_label: Label = $"Stock Label"
@onready var sold_out_banner: Control = $"Sold Out Banner"


func config(i, quantity):
	
	item = i
	shop_item["name"] = item["name"]
	shop_item["price"] = item["price"]
	shop_item["quantity"] = quantity
	shop_item["description"] = item["description"]

	draw_item()

func config_sell(i):
	
	item = i
	shop_item["name"] = item["name"]
	shop_item["price"] = item["price"] * SELL_MODIFIER
	shop_item["quantity"] = 1
	shop_item["description"] = item["description"]
	
	draw_item()
	
func draw_item():
	
	item_name.text = shop_item["name"]
	price.text = GlobalFuncs.format_as_money(shop_item["price"])
	stock_label.text = str(shop_item["quantity"])
	if shop_item["quantity"] == 0:
		sold_out_banner.visible = true
	
func update_quantity(quantity):
	shop_item["quantity"] += quantity
	draw_item()
	
func _on_area_2d_mouse_entered() -> void:
	hovering = true
	background.color.a = 0.5

	
func _on_area_2d_mouse_exited() -> void:
	hovering = false
	background.color.a = 1


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if hovering:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				background.color = Color.AQUA
		elif event is InputEventMouseButton and event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT:
				background.color = Color.WHITE
				GlobalSignal.item_selected.emit(self)
