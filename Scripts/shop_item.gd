extends Control

class_name Shop_Item

var item
var quantity 

func create(i, q) -> Shop_Item:
	var new_item = Shop_Item.new()
	new_item.item = i
	new_item.quantity = q
	return new_item
	
