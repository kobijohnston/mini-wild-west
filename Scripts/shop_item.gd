extends Control

class_name Shop_Item

var item
var quantity 

@onready var item_name: Label = $"Item Name"
@onready var price_label: Label = $Label

func create(i, q) -> Shop_Item:
	var new_item = Shop_Item.new()
	new_item.item = i
	new_item.quantity = q
	return new_item
	
func _process(delta: float) -> void:
	item_name.text = item.name
	price_label.text = "$" + str(item.price)
	
