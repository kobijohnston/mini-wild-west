extends Control

var shop_item = {
	"name": "",
	"price": 0,
	"quantity": 0
}

@onready var item_name: Label = $"Item Name"
@onready var price: Label = $Price


func config(item, quantity):
	
	shop_item["name"] = item["name"]
	shop_item["price"] = item["price"]
	shop_item["quantity"] = quantity
	print("Adding:", item["name"])

	draw_item()
	
func draw_item():
	item_name.text = shop_item["name"]
	price.text = "$" + str(shop_item["price"])

func update_quantity(quantity):
	
	shop_item["quantity"] += quantity
