class_name Item
extends Resource

@export var name : String
@export var description : String
@export var price: float
@export var sell_value : float
@export var sprite : Texture2D

static func create(new_name, desc, new_price, sell, image) -> Item:
	var i = Item.new()
	i.name = new_name
	i.description = desc
	i.price = new_price
	i.sell_value = sell
	i.sprite = image
	return i
