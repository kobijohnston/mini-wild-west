extends Area2D

var type = GlobalEnums.Item_Type.BASE
var has_item = false

var inventory_item_scene = preload("res://Scenes/Menus/Inventory/inventory_item.tscn")
@onready var marker_2d: Marker2D = $Marker2D

func add_item(item):
	
	var inventory_item = inventory_item_scene.instantiate()
	add_child(inventory_item)
	inventory_item.set_sprite(item["sprite"])
	has_item = true
