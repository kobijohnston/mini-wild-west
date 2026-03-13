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
	"sprite": "res://Assets/Sprites/Items/"
}

func create(name: String, desc: String, price: float, type: GlobalEnums.Item_Type, mod: int, sellable: bool, restockable: bool, image) -> Dictionary:
	item["name"] = name
	item["description"] = desc
	item["price"] = price
	item["type"] = type
	item["modifier"] = mod
	item["sellable"] = sellable
	item["restockable"] = restockable
	item["sprite"] += image
	return item

func copy() -> Dictionary:
	var new_item = {
		"name": item["name"],
		"description": item["description"],
		"price": item["price"],
		"type": item["type"],
		"modifier": item["modifier"],
		"sellable": item["sellable"],
		"restockable": item["restockable"],
		"sprite": item["sprite"]
	}
	return new_item
