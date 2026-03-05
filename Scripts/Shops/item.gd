class_name Item
extends Node

var item = {
	"name": "",
	"description": "",
	"price": 0,
	"type": GlobalEnums.Item_Type.BASE,
	"modifier": 0,
	"sellable": false,
	"restockable": false,
	"sprite": false
}

func create(name: String, desc: String, price: float, type: GlobalEnums.Item_Type, mod: int, sellable: bool, restockable: bool, image) -> Dictionary:
	item["name"] = name
	item["description"] = desc
	item["price"] = price
	item["type"] = type
	item["modifier"] = mod
	item["sellable"] = sellable
	item["restockable"] = restockable
	item["sprite"] = image
	return item
